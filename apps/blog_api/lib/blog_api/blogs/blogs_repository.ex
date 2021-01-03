defmodule BlogApi.Blogs.BlogsRepository do
  @moduledoc """
    This module is responsable for the CRUD of Blogs.
  """
  alias BlogApi.Blogs.Blog
  alias BlogApi.Repo
  alias BlogApi.Users.UsersRepository

  import Ecto.Query, only: [where: 3]

  @spec create(map()) :: {:ok, Blog.t()} | {:error, Ecto.Changeset.t()}
  def create(%{user_id: user_id} = attrs) do
    with {:ok, user} <- UsersRepository.get_user(%{user_id: user_id}) do
      user
      |> Ecto.build_assoc(:blogs, attrs)
      |> Blog.changeset(attrs)
      |> Repo.insert()
    end
  end

  @spec get_all() :: [Blog.t()] | []
  def get_all, do: Repo.all(Blog)

  @spec get(Ecto.UUID.t()) :: {:ok, Blog.t() | nil}
  def get(id), do: {:ok, Repo.get(Blog, id)}

  @spec update(Ecto.UUID.t(), map()) :: {:ok, Blog.t()} | {:error, Ecto.Changeset.t()}
  def update(blog_id, %{} = attrs) do
    with {:ok, blog} <- get(blog_id) do
      blog
      |> Blog.changeset(attrs)
      |> Repo.update()
    end
  end

  @spec delete(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete(id) do
    Blog
    |> where([blog], blog.id == ^id)
    |> Repo.delete_all()
  end
end
