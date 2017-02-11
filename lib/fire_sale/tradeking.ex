defmodule FireSale.Tradeking do
  alias FireSale.Oauth

  @consumer %{
    key: System.get_env("TRADEKING_CONSUMER_KEY"),
    secret: System.get_env("TRADEKING_CONSUMER_SECRET")
  }

  @token %{
    key: System.get_env("TRADEKING_TOKEN_KEY"),
    secret: System.get_env("TRADEKING_TOKEN_SECRET")
  }

  @url "https://api.tradeking.com/v1/market/ext/quotes.json?symbols="

  def get_quotes(symbols) do
    url = @url <> symbols <>
      "&fids=exch,symbol,ask,bid,last"

    auth_string = Oauth.hmac_sha1_auth_string(url, @consumer, @token)

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

    companies
  end
end
