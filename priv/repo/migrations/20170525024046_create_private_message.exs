defmodule EopChatBackend.Repo.Migrations.CreatePrivateMessage do
  use Ecto.Migration

  def change do
    create table(:private_messages) do
      add :content, :string
      add :sender_id, references(:users, on_delete: :nothing)
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:private_messages, [:sender_id])
    create index(:private_messages, [:receiver_id])

  end
end
