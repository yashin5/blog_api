defmodule BlogApi.Posts.Post do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogApi.{Blogs.Blog, Users.User}

  @required_fields [
    :user_id,
    :blog_id,
    :author,
    :title
  ]

  @optional_fields [
    :content
  ]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "posts" do
    field :title, :string
    field :author, :string
    field :content, :string
    field :reading_time, :string

    belongs_to(:user, User, type: :binary_id)
    belongs_to(:blog, Blog, type: :binary_id)

    timestamps()
  end

  def changeset(%__MODULE__{} = blog, attrs) do
    blog
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields ++ [:content])
    |> generate_reading_time()
  end

  defp generate_reading_time(%{valid?: true, changes: %{content: content}} = changeset) do
    reading_time =
      content
      |> String.split(" ", trim: true)
      |> length()
      |> Kernel.*(0.24)
      |> Float.to_string()

    change(changeset, %{reading_time: reading_time})
  end

  defp generate_reading_time(changeset), do: changeset
end
