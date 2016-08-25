defmodule FireSale.PageController do
  use FireSale.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
