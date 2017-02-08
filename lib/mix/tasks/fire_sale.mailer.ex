defmodule Mix.Tasks.FireSale.Mailer do
  use Mix.Task

  @shortdoc "Send alert emails"

  def run(_) do
    Mix.Task.run "app.start", []
    FireSale.AlertWorker.run
  end
end
