defmodule FireSale.AlertController do
  use FireSale.Web, :controller

  alias FireSale.Tradeking
  alias FireSale.Alert

  def index(conn, _params) do
    conn
    |> render(
      :index,
      alerts: current_user(conn).id |> alerts,
      changeset: Alert.changeset(%Alert{})
    )
  end

  def create(conn, %{"alert" => alert_params}) do
    alert_params = Map.put(
      alert_params,
      "user_id",
      Guardian.Plug.current_resource(conn).id
    )

    changeset = Alert.changeset(%Alert{}, alert_params)

    if changeset.valid? do
      stock_quote = Tradeking.get_quotes(alert_params["symbol"])

      if  List.first(stock_quote)[:exch] == "na" do
        changeset = Ecto.Changeset.add_error(
          changeset, :symbol, "not found"
        )
      end
    end

    if length(changeset.errors) > 0 do
      errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

      error_msg = errors
      |> Enum.map(fn h ->
        "#{elem(h,0) |> to_string |> String.capitalize} #{elem(h,1)}."
      end)
      |> Enum.join(" ")

      error_msg = "Failed to create alert. " <> error_msg
    end

    case Repo.insert(changeset) do
      {:ok, _alert} ->
        conn
        |> put_flash(:info, "Alert created successfully.")
        |> redirect(to: alert_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, error_msg)
        |> redirect(to: alert_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Repo.get!(Alert, id)

    Repo.delete!(alert)

    conn
    |> put_flash(:info, "Alert deleted successfully.")
    |> redirect(to: alert_path(conn, :index))
  end

  defp alerts(user_id) do
    Repo.all(
      from a in Alert,
      where: a.user_id == ^user_id,
      order_by: [a.symbol]
    )
  end
end
