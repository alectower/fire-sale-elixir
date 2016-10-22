defmodule FireSale.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Plug.Conn

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end

  def login(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(FireSale.User, email: email)

    cond do
      user && checkpw(given_pass, user.encrypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
