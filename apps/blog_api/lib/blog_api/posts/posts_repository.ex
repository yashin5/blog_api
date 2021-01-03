defmodule BlogApi.Posts.PostsRepository do
  @moduledoc """
    This module is responsable for the CRUD of Posts.
  """
  alias BlogApi.Blogs.BlogsRepository
  alias BlogApi.Posts.Post
  alias BlogApi.Repo
  alias BlogApi.Users.UsersRepository

  import Ecto.Query, only: [where: 3]

  @doc """
  Create a Post

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      PostsRepository.create(%{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      })
  """
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

  @doc """
  Get a Post

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      {:ok, %{id: post_id}} = PostsRepository.create(%{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"

      PostsRepository.get_post(post_id)

  """
  @spec get_post(Ecto.UUID.t()) :: {:ok, Post.t() | nil}
  def get_post(post_id), do: {:ok, Repo.get(Post, post_id)}

  @doc """
  Get all posts from a user

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      PostsRepository.get_user_posts(user_id)

  """
  @spec get_user_posts(Ecto.UUID.t()) :: {:ok, [Post.t()] | []} | {:error, Ecto.Changeset.t()}
  def get_user_posts(user_id) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Get all posts

  ## Examples

      PostsRepository.get_all()

  """
  @spec get_all() :: [Post.t()] | []
  def get_all, do: Repo.all(Post)

  @doc """
  Get all posts from a blog

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      PostsRepository.get_all_blog_posts(blog_id)

  """
  @spec get_all_blog_posts(Ecto.UUID.t()) :: {:ok, [Post.t()] | []} | {:error, Ecto.Changeset.t()}
  def get_all_blog_posts(blog_id) do
    Post
    |> where([post], post.blog_id == ^blog_id)
    |> Repo.all()
  end

  @doc """
  Update a Post

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      {:ok, %{id: post_id}} = PostsRepository.create(%{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      })

      PostsRepository.update(%{post_id: post_id}, %{title: "opa", content: "Somos buda"})
  """
  @spec update(%{post_id: Ecto.UUID.t()}, map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def update(%{post_id: post_id}, attrs) do
    with {:ok, post} <- get_post(post_id) do
      post
      |> Post.changeset_update(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Delete a Post

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      {:ok, %{id: post_id}} = PostsRepository.create(%{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      })

      PostsRepository.delete_post(post_id)
  """
  @spec delete_post(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete_post(post_id: post_id) do
    Post
    |> where([post], post.id == ^post_id)
    |> Repo.delete_all()
  end

  @doc """
  Delete all user posts

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      PostsRepository.delete_post(user_id)
  """
  @spec delete_all_user_post(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete_all_user_post(user_id) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.delete_all()
  end

  @doc """
  Delete all blog posts

  ## Examples
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })        

      PostsRepository.delete_post(blog_id)
  """
  @spec delete_all_user_post(Ecto.UUID.t()) :: {integer(), nil | [term()]}
  def delete_all_blog_post(blog_id) do
    Post
    |> where([post], post.blog_id == ^blog_id)
    |> Repo.delete_all()
  end
end
