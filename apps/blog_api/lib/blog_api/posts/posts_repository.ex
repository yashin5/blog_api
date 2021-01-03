defmodule BlogApi.Posts.PostsRepository do
  @moduledoc """
    This module is responsable for the CRUD of Posts.
  """
  alias BlogApi.Blogs.BlogsRepository
  alias BlogApi.Posts.Post
  alias BlogApi.Repo
  alias BlogApi.Users.UsersRepository

  import Ecto.Query, only: [where: 3]

  @spec create(map()) :: {:ok, Post.t()} | {:error, {:error, Ecto.Changeset.t()}}
  def create(%{blog_id: blog_id, user_id: user_id} = attrs) do
    with {:ok, _blog} <- BlogsRepository.get(blog_id),
         {:ok, %{name: name}} <- UsersRepository.get_user(%{user_id: user_id}) do
      attrs_with_author = Map.put(attrs, :author, name)

      %Post{}
      |> Post.changeset(attrs_with_author)
      |> Repo.insert()
    end
  end

  @spec get_post(Ecto.UUID.t()) :: {:ok, Post.t() | nil}
  def get_post(post_id), do: {:ok, Repo.get(Post, post_id)}

  @spec get_user_posts(Ecto.UUID.t()) :: {:ok, []} | {:error, Ecto.Changeset.t()}
  def get_user_posts(user_id) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.all()
  end

  @spec get_all() :: [Post.t()] | []
  def get_all, do: Repo.all(Post)

  @spec delete_user_post(map()) :: {integer(), nil | [term()]}
  def delete_user_post(%{user_id: user_id, post_id: post_id}) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> where([post], post.id == ^post_id)
    |> Repo.delete_all()
  end

  @spec delete_all_user_post(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete_all_user_post(user_id) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.delete_all()
  end
end
