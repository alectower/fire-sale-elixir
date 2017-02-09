defmodule FireSale.AlertWorker do
  alias FireSale.Alert
  alias FireSale.User
  alias FireSale.Repo
  alias FireSale.Oauth
  alias FireSale.AlertMailer
  import Ecto.Query

  def run do
    consumer = %{
      key: System.get_env("TRADEKING_CONSUMER_KEY"),
      secret: System.get_env("TRADEKING_CONSUMER_SECRET")
    }

    token = %{
      key: System.get_env("TRADEKING_TOKEN_KEY"),
      secret: System.get_env("TRADEKING_TOKEN_SECRET")
    }

    Repo.all(User)
    |> Enum.each(fn (user) ->
      alerts = Repo.all(
        from a in Alert,
        where: a.user_id == ^user.id
      )

      if Enum.count(alerts) > 0 do
        url = "https://api.tradeking.com/v1/market/ext/quotes.json?symbols="
        url = url <> (alerts |> Enum.map(fn (a) -> a.symbol end) |> Enum.join(","))
        url = url <> "&fids=symbol,ask,bid,last"

        auth_string = Oauth.hmac_sha1_auth_string(url, consumer, token)

        HTTPotion.start

        resp = HTTPotion.get url, [
          headers: [
            "Accept": "application/json",
            "Authorization": auth_string
          ]
        ]

        companies = Poison.Parser.parse!(
          resp.body,
          keys: :atoms
        )[:response][:quotes][:quote]

        if is_map(companies) do
          companies = [companies]
        end

        alerts = alerts |> Enum.flat_map_reduce(%{}, fn n, acc ->
          r = acc |> Map.put(n.symbol, n.price / 100)
          {[n], r}
        end) |> elem(1)

        alert_prices = companies |> Enum.map(fn (company) ->
          alert_price =  alerts[company[:symbol]]
          ask_price = Float.parse(company[:ask]) |> elem(0)
          bid_price = Float.parse(company[:bid]) |> elem(0)
          last_price = Float.parse(company[:last]) |> elem(0)
          price = if last_price > 0 do last_price else ask_price end
          if price <= alert_price do
            %{
              symbol: company[:symbol],
              alert_price: alert_price,
              ask_price: ask_price,
              bid_price: bid_price,
              last_price: last_price,
              price: price
            }
          end
        end)|> Enum.reject(fn (a) -> is_nil(a) end)

        unless Enum.empty?(alert_prices) do
          IO.puts 'sending email...'
          AlertMailer.send_alert user.email, alert_prices
        end
      end
    end)
  end
end
