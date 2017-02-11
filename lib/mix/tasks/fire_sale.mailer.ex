defmodule Mix.Tasks.FireSale.Mailer do
  use Mix.Task

  @shortdoc "Send weekly alert emails"

  def run(_) do
    day = :erlang.date |> :calendar.day_of_the_week

    if day != 6 && day != 7 do
      Mix.shell.info "Sending alerts!"
      Mix.Task.run "app.start", []
      FireSale.AlertWorker.run
    else
      Mix.shell.info "It's the weekend, party!"
    end
  end
end
