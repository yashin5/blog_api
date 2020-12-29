defmodule BlogApi.Repo.Migrations.Blogs do
  use Ecto.Migration

  def change do
    create table(:blogs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :description, :string

      add(:user_id, references(:users, type: :uuid), null: false)

      timestamps()
    end
  end
end
