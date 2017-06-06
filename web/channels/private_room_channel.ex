defmodule EopChatBackend.PrivateRoomChannel do
  use Phoenix.Channel
  alias EopChatBackend.Repo
  alias EopChatBackend.User
  alias EopChatBackend.PrivateMessage
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
            cond do
              socket.assigns[:current_user].auth0_id == first_id ->
                the_user = Repo.get_by(User, auth0_id: second_id)
                if the_user == nil do
                  {:error, %{reason: "Invalid id"}}
                else
                  {:ok, socket}
                end
              socket.assigns[:current_user].auth0_id == second_id ->
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
    "private:"<>concated_ids = socket.topic
    List.first(List.delete(String.split(concated_ids,","), "auth0|5924d91fd9643f3235f49e3a"))
    receiver_auth0_id = concated_ids
                 |> String.split(",")
                 |> List.delete(socket.assigns[:current_user].auth0_id)
                 |> List.first()
    sender_auth0_id = socket.assigns[:current_user].auth0_id
    receiver_user_id = Repo.get_by(User, auth0_id: receiver_auth0_id).id
    sender_user_id = Repo.get_by(User, auth0_id: sender_auth0_id).id
    case Repo.insert(%PrivateMessage{
                        content: msg["body"],
                        sender_id: sender_user_id,
                        receiver_id: receiver_user_id
                      }) do
      {:ok, private_message} ->
        broadcast! socket, "new:msg", %{id: private_message.id, sender_id: socket.assigns[:current_user].auth0_id, body: msg["body"]}
        {:noreply, socket}
      {:error, private_message_changeset} ->
        IO.puts private_message_changeset.errors
        {:noreply, socket}               
    end
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