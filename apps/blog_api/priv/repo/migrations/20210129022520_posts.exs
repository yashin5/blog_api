defmodule BlogApi.Repo.Migrations.Posts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, null: false
      add :author, :string, null: false
      add :content, :text, null: false
      add :reading_time, :string, null: false

      add(:user_id, references(:users, type: :uuid), null: false)
      add(:blog_id, references(:blogs, type: :uuid), null: false)

      timestamps()
    end
  end
end
