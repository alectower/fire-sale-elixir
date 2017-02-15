defmodule FireSale.AlertMailer do
  use Bamboo.Phoenix, view: FireSale.EmailView
  import Bamboo.Email
  alias FireSale.Mailer

  def send_alert(email_address, alerts) do
    new_email
    |> put_html_layout({FireSale.LayoutView, "email.html"})
    |> from({"FireSale", "alerts@firesale.com"})
    |> to(email_address)
    |> subject("FireSale Alerts!")
    |> assign(:alerts, alerts)
    |> render(:alert)
    |> Mailer.deliver_now
  end
end
