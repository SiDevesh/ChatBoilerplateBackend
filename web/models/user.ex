defmodule EopChatBackend.User do
  use EopChatBackend.Web, :model

  schema "users" do
    field :auth0_id, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:auth0_id])
    |> validate_required([:auth0_id])
  end
end
