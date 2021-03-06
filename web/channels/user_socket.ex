defmodule EopChatBackend.UserSocket do
  use Phoenix.Socket
  alias EopChatBackend.Repo
  alias EopChatBackend.User

  ## Channels
  channel "private:*", EopChatBackend.PrivateRoomChannel
  channel "group:*", EopChatBackend.GroupRoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
  timeout: 45_000
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => jwt}, socket) do
    case Guardian.decode_and_verify(jwt) do
      { :ok, claims } ->
        the_user = Repo.get_by(User, auth0_id: claims["sub"])
        if the_user == nil do
          :error
        else
          {:ok, assign(socket, :current_user, the_user)}
        end
      { :error, _reason } -> :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     EopChatBackend.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
