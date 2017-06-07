defmodule EopChatBackend.V1.PreviousMessagesController do
  use EopChatBackend.Web, :controller
  alias EopChatBackend.Repo
  alias EopChatBackend.User
  alias EopChatBackend.PrivateMessage
  import Ecto.Query

        #if !@page_no.to_i.between?(1,((@apps.count.to_f/ITEMS_PER_PAGE).ceil))
        #  render json: { errors: ["Invalid page number."] }, status: 400 and return
        #end
        #
        #@last_page_value = @page_no == (@apps.count.to_f/ITEMS_PER_PAGE).ceil
        #@apps = @apps.offset((@page_no - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)

  def private_messages(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    param_user = Repo.get_by(User, auth0_id: params["auth0_id"])
    if param_user == nil || param_user.id == user.id  do
      conn
      |> put_status(400)
      |> json %{errors: ["Invalid user id"]}
    else
      #query = from u in PrivateMessage,
      #        where: u.sender_id == ^user.auth0_id and u.receiver_id == ^params.auth0_id or u.sender_id == ^params.auth0_id and u.receiver_id == ^user.auth0_id
      query1 = from u in PrivateMessage,
               where: u.sender_id == ^user.id or u.sender_id == ^param_user.id
      query2 = from u in query1,
               where: u.receiver_id == ^user.id or u.receiver_id == ^param_user.id
      query3 = from u in query2,
               order_by: [desc: u.inserted_at],
               select: struct(u, [:id, :content, :sender_id, :receiver_id, :inserted_at])
      #here an invalid page number case would be if,
      #user gave last message id as 500 when there have been only 50 messages,
      #in this case it will be treated as no last case since,
      #since everything will be less than 500,
      #so no need to handle,
      #if they give -something it will return nothing since everything is greateer than negative,
      #so no need to handle this too
      #Also now client can now last page when it receive response with empty array
      if Map.has_key?(params, "last") do
        query4 = from u in query3,
                 where: u.id < ^params["last"],
                 limit: 20
      else
        query4 = from u in query3,
                 limit: 20      
      end
      messages = Repo.all(query4)
      conn
      |> json %{messages: Enum.map(messages, &message_json/1)}
    end
  end

  defp message_json(message) do
    %{
      id: message.id,
      content: message.content,
      sender_id: Repo.get_by(User, id: message.sender_id).auth0_id,
      receiver_id: Repo.get_by(User, id: message.receiver_id).auth0_id,
      inserted_at: message.inserted_at
    }
  end

end
