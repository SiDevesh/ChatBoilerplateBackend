defmodule EopChatBackend.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias EopChatBackend.Repo
  alias EopChatBackend.User
  import Ecto.Query

  def find_or_create(user) do
    query = from u in User,
            where: u.auth0_id == ^user.auth0_id
    Repo.one(query) || Repo.insert!(user)
  end

  def for_token(user = %User{}), do: { :ok, "#{user.auth0_id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token(auth0_id), do: { :ok, find_or_create(%{auth0_id: auth0_id}) }
  def from_token(_), do: { :error, "Unknown resource type" }
end