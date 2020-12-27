defmodule BlogApi.Repo.Migrations.Blogs do
  use Ecto.Migration

  def change do
    create table(:blogs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :description, :string

      timestamps()
    end
  end
end
