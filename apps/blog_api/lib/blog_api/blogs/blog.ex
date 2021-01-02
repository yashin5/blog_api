defmodule BlogApi.Blogs.Blog do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogApi.{Posts.Post, Users.User}

  @required_fields [
    :name,
    :user_id
  ]

  @optional_fields [
    :description
  ]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "blogs" do
    field :name, :string
    field :description, :string

    belongs_to(:user, User, type: :binary_id)

    has_many(:posts, Post)

    timestamps()
  end

  def changeset(%__MODULE__{} = blog, attrs) do
    blog
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
