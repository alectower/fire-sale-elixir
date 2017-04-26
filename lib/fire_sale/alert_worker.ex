defmodule FireSale.AlertWorker do
  alias FireSale.Alert
  alias FireSale.User
  alias FireSale.Repo
  alias FireSale.AlertMailer
  alias FireSale.Tradeking
  import Ecto.Query

  def run do
    Repo.all(User)
    |> Enum.each(fn (user) ->
      alerts = Repo.all(
        from a in Alert,
        where: a.user_id == ^user.id,
        order_by: a.symbol
      )

      if Enum.count(alerts) > 0 do
        symbols = alerts
        |> Enum.map(fn (a) ->
          a.symbol end
        )
        |> Enum.join(",")

        companies = Tradeking.get_quotes(symbols)

        alerts = alerts
        |> Enum.flat_map_reduce(%{}, fn n, acc ->
          r = acc |> Map.put(n.symbol, n.price / 100)
          {[n], r}
        end)
        |> elem(1)

        alert_prices = companies |> Enum.map(fn (company) ->
          alert_price =  alerts[company[:symbol]]
          ask_price = Float.parse(company[:ask]) |> elem(0)
          bid_price = Float.parse(company[:bid]) |> elem(0)
          last_price = Float.parse(company[:last]) |> elem(0)
          close_price = Float.parse(company[:cl]) |> elem(0)
          change_price = Float.parse(company[:chg]) |> elem(0)
          price = if last_price > 0 do last_price else ask_price end
          if price <= alert_price do
            %{
              exchange: company[:exch],
              symbol: company[:symbol],
              alert_price: alert_price,
              ask_price: ask_price,
              bid_price: bid_price,
              last_price: last_price,
              price: price,
              close_price: close_price,
              change_price: change_price
            }
          end
        end)|> Enum.reject(fn (a) -> is_nil(a) end)

        unless Enum.empty?(alert_prices) do
          AlertMailer.send_alert user.email, alert_prices
        end
      end
    end)
  end
end
