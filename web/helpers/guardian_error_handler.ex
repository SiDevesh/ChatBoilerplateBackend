defmodule EopChatBackend.GuardianErrorHandler do
  use EopChatBackend.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: ["Authentication Required"]})
  end

  def no_resource(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: ["Resource Required"]})
  end

  def email_not_verified(conn, _params) do
    conn
    |> put_status(403)
    |> json(%{errors: ["Verify Email"]})
  end

  #def email_not_verified(conn, _params) do
  #  respond(conn, response_type(conn), 403, "Verify Email")
  #end

end