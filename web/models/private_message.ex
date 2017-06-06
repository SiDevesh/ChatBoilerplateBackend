defmodule EopChatBackend.PrivateMessage do
  use EopChatBackend.Web, :model

  schema "private_messages" do
    field :content, :string
    belongs_to :sender, EopChatBackend.User
    belongs_to :receiver, EopChatBackend.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required(:content)
    |> validate_length(:content, min: 1)
    |> validate_people_unique
  end

defp validate_people_unique(changeset) do
  sender_id = get_field(changeset, :sender_id)
  receiver_id = get_field(changeset, :receiver_id)
  if sender_id != receiver_id do
    changeset
  else
    add_error(changeset, :sender_id, "can't be same as receiver id.")
    add_error(changeset, :receiver_id, "can't be same as as id.")
  end
end

end
