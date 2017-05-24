defmodule EopChatBackend.V1.OverviewController do
  use EopChatBackend.Web, :controller

  def index(conn, _params) do
  	user = Guardian.Plug.current_resource(conn)
    json conn, %{id: user.auth0_id}
  end

end
