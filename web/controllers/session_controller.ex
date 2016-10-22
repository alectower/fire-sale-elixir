defmodule FireSale.SessionController do
  use FireSale.Web, :controller

  alias FireSale.User
  alias FireSale.UserQuery

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => %{"email" => nil, "password" => nil}}) do
    conn
    |> put_flash(:error, "Must provide username and password")
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"email" => user, "password" => pass}}) do
    case FireSale.Auth.login(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        logged_in_user = Guardian.Plug.current_resource(conn)

        conn
        |> put_flash(:info, "Signed in successfully")
        |> redirect(to: alert_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "User does not exist")
        |> render("new.html")
     end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end
end
