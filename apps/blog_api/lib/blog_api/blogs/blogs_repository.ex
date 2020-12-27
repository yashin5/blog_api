defmodule BlogApi.Blogs.BlogsRepository do
  alias BlogApi.Blogs.Blog
  alias BlogApi.Repo
  import Ecto.Query, only: [where: 3]

  def create(attrs \\ %{}) do
    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
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
