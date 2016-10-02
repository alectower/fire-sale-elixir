defmodule FireSale.AlertView do
  use FireSale.Web, :view

  def price(alert) do
    List.first :io_lib.format("~.2f", [alert.price / 100])
  end

  def symbolLink(alert) do
    "https://www.google.com/finance?q=#{alert.symbol}"
  end
end
