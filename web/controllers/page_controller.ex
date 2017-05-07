defmodule EopChatBackend.PageController do
  use EopChatBackend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
