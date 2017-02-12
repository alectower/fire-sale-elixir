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

  @tradeking_url "https://api.tradeking.com/v1/"

  @quotes_endpoint "market/ext/quotes.json?symbols="

  @toplist_endpoint "market/toplists/"

  @news_endpoint "market/news/"

  @news_search_endpoint @news_endpoint <> "search.json?symbols="

  @options_endpoint "market/options/"

  def get_quotes(symbols) do
    url = @tradeking_url <> @quotes_endpoint <> symbols <>
      "&fids=exch,symbol,ask,bid,last," <>
      "pe,eps,yield,div,divexdate,divfreq," <>
      "prbook,wk52hi,wk52hidate,wk52lo,wk52lodate"

    make_request(url)
    |> parse_response([:quotes, :quote])
  end

  def get_top_list(list) do
    url = @tradeking_url <> @toplist_endpoint <> list <> ".json"

    make_request(url)
    |> parse_response([:quotes, :quote])
  end

  def get_news(symbols) do
    url = @tradeking_url <> @news_search_endpoint <> symbols <> "&maxhist=5"

    make_request(url)
    |> parse_response([:articles, :article])
  end

  def get_story(news_id) do
    url = @tradeking_url <> @news_endpoint <> news_id <> ".json"

    make_request(url)
    |> parse_response([:article])
  end

  def get_options(symbol) do
    url = @tradeking_url <> @options_endpoint <> "search.json?symbol=" <> symbol

    make_request(url)
    |> parse_response([:quotes, :quote])
  end

  def get_option_strikes(symbol) do
    url = @tradeking_url <> @options_endpoint <> "strikes.json?symbol=" <> symbol

    make_request(url)
    |> parse_response([:prices, :price])
  end

  defp make_request(url) do
    auth_string = Oauth.hmac_sha1_auth_string(url, @consumer, @token)

    HTTPotion.start

    HTTPotion.get url, [
      headers: [
        "Accept": "application/json",
        "Authorization": auth_string
      ]
    ]
  end

  defp parse_response(resp, map_keys) do
    resources = Poison.Parser.parse!(
      resp.body,
      keys: :atoms
    )

    resources =
    resources
    |> get_in([:response | map_keys])

    resources = cond do
      is_map(resources) -> [resources]
      true -> resources
    end

    resources
  end
end
