defmodule FireSale.Router do
  use FireSale.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FireSale do
    pipe_through :browser # Use the default browser stack

    get "/", AlertController, :index

    resources "/alerts", AlertController, only: [:index, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", FireSale do
  #   pipe_through :api
  # end
end
