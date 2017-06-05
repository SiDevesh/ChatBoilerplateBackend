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
    |> validate_required([:content])
  end
end
