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
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated, handler: EopChatBackend.GuardianErrorHandler
  plug EopChatBackend.Plugs.EmailVerified, handler: EopChatBackend.GuardianErrorHandler
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureResource, handler: EopChatBackend.GuardianErrorHandler
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
