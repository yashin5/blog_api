defmodule BlogApi.Blogs.Blog do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogApi.Users.User

  @required_fields [
    :name
  ]

  @optional_fields [
    :description
  ]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "blogs" do
    field :name, :string
    field :description, :string

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset(%__MODULE__{} = blog, attrs) do
    blog
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
