defmodule EopChatBackend.V1.OverviewController do
  use EopChatBackend.Web, :controller
  alias EopChatBackend.Repo
  alias EopChatBackend.User
  alias EopChatBackend.PrivateMessage
  import Ecto.Query

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    id_pairs_by_me = Repo.all(from p in PrivateMessage, where: p.sender_id == ^user.id, group_by: p.receiver_id, select: {p.receiver_id, max(p.id)})
    id_pairs_to_me = Repo.all(from p in PrivateMessage, where: p.receiver_id == ^user.id, group_by: p.sender_id, select: {p.sender_id, max(p.id)})
    id_map_by_me = Enum.into(id_pairs_by_me, %{})
    id_map_to_me = Enum.into(id_pairs_to_me, %{})
    unsorted_final_id_list = Map.to_list(Map.merge(id_map_by_me, id_map_to_me, fn(_k, v1, v2) -> if (v1>v2), do: v1, else: v2 end))
    final_id_list = Enum.sort(unsorted_final_id_list, &(elem(&1,1) >= elem(&2,1)))
    conn
    |> json(%{
      people: Enum.map(final_id_list,
        fn({k,v})->
          %{user_id: Repo.get(User, k).auth0_id, chat_content: Repo.get(PrivateMessage, v).content}
        end
      )
    })
  end

end
