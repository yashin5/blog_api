defmodule BlogApi.Posts.PostsRepository do
  alias BlogApi.Blogs.BlogsRepository
  alias BlogApi.Posts.Post
  alias BlogApi.Users.UsersRepository
  alias BlogApi.Repo

  import Ecto.Query, only: [where: 3]

  def create(%{blog_id: blog_id, user_id: user_id} = attrs) do
    with {:ok, _blog} <- BlogsRepository.get(blog_id),
         {:ok, %{name: name}} <- UsersRepository.get_user(%{user_id: user_id}) do
      attrs_with_author = Map.put(attrs, :author, name)

      %Post{}
      |> Post.changeset(attrs_with_author)
      |> Repo.insert()
    end
  end

  def get_user_posts(user_id) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.all()
  end

  def get_all(), do: Repo.all(Post)

  def delete_user_post(%{user_id: user_id, post_id: post_id}) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> where([post], post.id == ^post_id)
    |> Repo.delete_all()
  end

  def delete_all_user_post(%{user_id: user_id}) do
    Post
    |> where([post], post.user_id == ^user_id)
    |> Repo.delete_all()
  end
end
