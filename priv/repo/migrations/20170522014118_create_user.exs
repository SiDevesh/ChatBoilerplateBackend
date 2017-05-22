defmodule EopChatBackend.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :auth0_id, :string

      timestamps()
    end

  end
end
