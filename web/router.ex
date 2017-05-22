defmodule EopChatBackend.Router do
  use EopChatBackend.Web, :router

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

pipeline :api_auth do
  plug :accepts, ["json"]
  plug Joken.Plug,
    verify: &EopChatBackend.JWTHelpers.verify/0,
    on_error: &EopChatBackend.JWTHelpers.error/2
  #plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource
end  

  scope "/", EopChatBackend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", EopChatBackend do
    pipe_through :api_auth
      scope "/v1", V1, as: :v1 do
        get "/overview", OverviewController, :index
      end
  end
end
