defmodule FireSale.Router do
  use FireSale.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: FireSale.Token
    plug Guardian.Plug.LoadResource
  end

  scope "/", FireSale do
    pipe_through [:browser]

    resources "/sessions", SessionController,
      only: [:new, :create, :delete]
  end

  scope "/", FireSale do
    pipe_through [:browser, :browser_auth]

    get "/", AlertController, :index

    resources "/users", UserController,
      only: [:show, :index, :update]

    resources "/alerts", AlertController,
      only: [:index, :create, :delete]
  end
end
