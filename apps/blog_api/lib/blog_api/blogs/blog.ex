defmodule BlogApi.Blogs.Blog do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

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

    timestamps()
  end

  def changeset(%__MODULE__{} = blog, attrs) do
    blog
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
