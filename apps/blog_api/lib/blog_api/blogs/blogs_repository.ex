defmodule BlogApi.Blogs.BlogsRepository do
  @moduledoc """
    This module is responsable for the CRUD of Blogs.
  """
  alias BlogApi.Blogs.Blog
  alias BlogApi.Repo
  alias BlogApi.Users.UsersRepository

  import Ecto.Query, only: [where: 3]

  @doc """
  Create a blog

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      BlogsRepository.create(%{
        user_id: user_id,
        name: "Jurema's blog",
        description: "that's it!"
      })        
  """
  @spec create(map()) :: {:ok, Blog.t()} | {:error, Ecto.Changeset.t()}
  def create(%{user_id: user_id} = attrs) do
    with {:ok, user} <- UsersRepository.get_user(%{user_id: user_id}) do
      user
      |> Ecto.build_assoc(:blogs, attrs)
      |> Blog.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Get all blogs

  ## Examples
      BlogsRepository.get_all()  
  """
  @spec get_all() :: [Blog.t()] | []
  def get_all, do: Repo.all(Blog)

  @doc """
  Get a blog

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} = BlogsRepository.create(%{
        user_id: user_id,
        name: "Jurema's blog",
        description: "that's it!"
      })        

      BlogsRepository.get(blog_id)
  """
  @spec get(Ecto.UUID.t()) :: {:ok, Blog.t() | nil}
  def get(id), do: {:ok, Repo.get(Blog, id)}

  @doc """
  Update a blog

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} = BlogsRepository.create(%{
        user_id: user_id,
        name: "Jurema's blog",
        description: "that's it!"
      })        

      BlogsRepository.update(%{blog_id: blog_id}, %{name: "Jurema's blog"})
  """
  @spec update(%{blog_id: Ecto.UUID.t()}, map()) :: {:ok, Blog.t()} | {:error, Ecto.Changeset.t()}
  def update(%{blog_id: blog_id}, %{} = attrs) do
    with {:ok, blog} <- get(blog_id) do
      blog
      |> Blog.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Delete a blog

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} = BlogsRepository.create(%{
        user_id: user_id,
        name: "Jurema's blog",
        description: "that's it!"
      })        

      BlogsRepository.delete(blog_id)
  """
  @spec delete(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete(id) do
    Blog
    |> where([blog], blog.id == ^id)
    |> Repo.delete_all()
  end
end
