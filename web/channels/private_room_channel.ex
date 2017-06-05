defmodule EopChatBackend.PrivateRoomChannel do
  use Phoenix.Channel
  alias EopChatBackend.Repo
  alias EopChatBackend.User
  #require Logger

  def join("private:" <> concated_ids, _message, socket) do
    if length(String.split(concated_ids, ",")) == 2 do
      [first_id, second_id] = String.split(concated_ids, ",")
      cond do
        first_id == second_id ->
          {:error, %{reason: "Same ids"}}
        first_id > second_id ->
          {:error, %{reason: "Improper ordered ids"}}
        first_id < second_id ->
          if socket.assigns[:current_user].auth0_id == first_id or socket.assigns[:current_user].auth0_id == second_id do
            if socket.assigns[:current_user].auth0_id == first_id do
              the_user = Repo.get_by(User, auth0_id: second_id)
              if the_user == nil do
                {:error, %{reason: "Invalid id"}}
              else
                {:ok, socket}
              end
            end
            if socket.assigns[:current_user].auth0_id == second_id do
              the_user = Repo.get_by(User, auth0_id: first_id)
              if the_user == nil do
                {:error, %{reason: "Invalid id"}}
              else
                {:ok, socket}
              end
            end
          else
            {:error, %{reason: "Unauthorised"}}
          end
      end
    else
      {:error, %{reason: "Improper ids"}}
    end
  end

  #def handle_info({:after_join, msg}, socket) do
  #  broadcast! socket, "user:entered", %{user: msg["user"]}
  #  push socket, "join", %{status: "connected"}
  #  {:noreply, socket}
  #end
  #def handle_info(:ping, socket) do
  #  push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
  #  {:noreply, socket}
  #end

  def handle_in("new:msg", msg, socket) do
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:noreply, socket}
  end

  #def terminate(reason, _socket) do
  #  Logger.debug"> leave #{inspect reason}"
  #  :ok
  #end

  #def handle_in("new:msg", msg, socket) do
  #  broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
  #  {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  #end

end