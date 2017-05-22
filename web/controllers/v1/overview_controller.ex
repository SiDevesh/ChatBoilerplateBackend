defmodule EopChatBackend.V1.OverviewController do
  use EopChatBackend.Web, :controller
  #plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  #alias EopChatBackend.Repo
  #alias EopChatBackend.User
  #import Ecto.Query

  #def find_or_create(user) do
  #  query = from u in User,
  #          where: u.auth0_id == ^user.auth0_id
  #  Repo.one(query) || Repo.insert!(user)
  #end

  def index(conn, _params) do
  	#user = Guardian.Plug.current_resource(conn)
    json conn, %{id: 1}
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: ["Authentication Required"]})
  end

end
