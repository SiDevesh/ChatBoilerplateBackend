defmodule EopChatBackend.V1.OverviewController do
  use EopChatBackend.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
  	user = Guardian.Plug.current_resource(conn)
    json conn, %{id: user.auth0_id}
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: ["Authentication Required"]})
  end

end
