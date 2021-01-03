defmodule Posts.PostsRepositoryTest do
  use BlogApi.DataCase, async: true

  alias BlogApi.Blogs.BlogsRepository
  alias BlogApi.Posts.{Post, PostsRepository}
  alias BlogApi.Users.UsersRepository

  describe "create/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      {:ok, %{user_id: user_id, blog_id: blog_id}}
    end

    test "should create a post", %{user_id: user_id, blog_id: blog_id} do
      %{title: title, content: content} =
        attrs = %{
          title: "Cobra Kai",
          user_id: user_id,
          blog_id: blog_id,
          content: "Myohon rangekyo"
        }

      assert {:ok,
              %Post{
                title: ^title,
                user_id: ^user_id,
                blog_id: ^blog_id,
                content: ^content,
                author: "Yaxx",
                id: _id
              }} = PostsRepository.create(attrs)
    end

    test "if context is empty, should return a error", %{user_id: user_id, blog_id: blog_id} do
      attrs = %{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: ""
      }

      assert {:error,
              %Ecto.Changeset{
                errors: [content: {"can't be blank", [validation: :required]}]
              }} = PostsRepository.create(attrs)
    end
  end

  describe "get/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      post_params = %{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      }

      {:ok, post} = PostsRepository.create(post_params)

      Enum.each(1..2, fn _each ->
        PostsRepository.create(post_params)
      end)

      {:ok, %{post: post}}
    end

    test "should return a post", %{
      post: %{id: post_id, title: title, user_id: user_id, blog_id: blog_id, content: content}
    } do
      assert {:ok, %{title: ^title, content: ^content, user_id: ^user_id, blog_id: ^blog_id}} =
               PostsRepository.get_post(post_id)
    end
  end

  describe "get_user_posts/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      Enum.each(1..3, fn _each ->
        PostsRepository.create(%{
          title: "Cobra Kai",
          user_id: user_id,
          blog_id: blog_id,
          content: "Myohon rangekyo"
        })
      end)

      {:ok, %{user_id: user_id}}
    end

    test "should return all posts from a user", %{user_id: user_id} do
      assert length(PostsRepository.get_user_posts(user_id)) == 3
    end
  end

  describe "get_all/0" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      Enum.each(1..3, fn _each ->
        PostsRepository.create(%{
          title: "Cobra Kai",
          user_id: user_id,
          blog_id: blog_id,
          content: "Myohon rangekyo"
        })
      end)
    end

    test "should return all posts from a user" do
      assert length(PostsRepository.get_all()) == 3
    end
  end

  describe "delete_post/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      post_params = %{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      }

      {:ok, %{id: post_id}} = PostsRepository.create(post_params)

      Enum.each(1..2, fn _each ->
        PostsRepository.create(post_params)
      end)

      {:ok, %{user_id: user_id, post_id: post_id}}
    end

    test "should delete all posts from a user", %{user_id: user_id, post_id: post_id} do
      assert length(PostsRepository.get_user_posts(user_id)) == 3

      assert PostsRepository.delete_post(post_id) == {1, nil}

      assert length(PostsRepository.get_user_posts(user_id)) == 2
    end
  end

  describe "update/2" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      post_params = %{
        title: "Cobra Kai",
        user_id: user_id,
        blog_id: blog_id,
        content: "Myohon rangekyo"
      }

      {:ok, %{id: post_id}} = PostsRepository.create(post_params)

      Enum.each(1..2, fn _each ->
        PostsRepository.create(post_params)
      end)

      {:ok, %{user_id: user_id, post_id: post_id}}
    end

    test "should update post", %{post_id: post_id} do
      assert {:ok, %{title: "opa", content: "Somos buda"}} =
               PostsRepository.update(%{post_id: post_id}, %{title: "opa", content: "Somos buda"})
    end
  end

  describe "delete_all_user_post/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      Enum.each(1..3, fn _each ->
        PostsRepository.create(%{
          title: "Cobra Kai",
          user_id: user_id,
          blog_id: blog_id,
          content: "Myohon rangekyo"
        })
      end)

      {:ok, %{user_id: user_id, blog_id: blog_id}}
    end

    test "should delete all posts from a user", %{user_id: user_id} do
      assert length(PostsRepository.get_user_posts(user_id)) == 3
      assert PostsRepository.delete_all_user_post(user_id) == {3, nil}
      assert Enum.empty?(PostsRepository.get_user_posts(user_id))
    end
  end

  describe "delete_all_blog_post/1" do
    setup do
      {:ok, %{id: user_id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, %{id: blog_id}} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      Enum.each(1..3, fn _each ->
        PostsRepository.create(%{
          title: "Cobra Kai",
          user_id: user_id,
          blog_id: blog_id,
          content: "Myohon rangekyo"
        })
      end)

      {:ok, %{blog_id: blog_id}}
    end

    test "should delete all posts from a blog", %{blog_id: blog_id} do
      assert length(PostsRepository.get_all_blog_posts(blog_id)) == 3
      assert PostsRepository.delete_all_blog_post(blog_id) == {3, nil}
      assert Enum.empty?(PostsRepository.get_all_blog_posts(blog_id))
    end
  end
end
