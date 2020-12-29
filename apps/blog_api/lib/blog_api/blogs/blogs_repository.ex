defmodule BlogApi.Blogs.BlogsRepository do
  alias BlogApi.Blogs.Blog
  alias BlogApi.Repo
  alias BlogApi.Users.UserRepository

  import Ecto.Query, only: [where: 3]

  def create(%{user_id: user_id} = attrs \\ %{}) do
    case UserRepository.get_user(%{user_id: user_id}) do
      {:ok, user} ->
        user
        |> Ecto.build_assoc(:blogs, attrs)
        |> Blog.changeset(attrs)
        |> Repo.insert()

      error ->
        error
    end
  end

  def get_all, do: Repo.all(Blog)

  def get(id), do: Repo.get(Blog, id)

  def update(blog, attrs \\ %{}) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  def delete(id) do
    Blog
    |> where([blog], blog.id == ^id)
    |> Repo.delete_all()
  end
end
