defmodule Blogs.BlogsRepositoryTest do
  use BlogApi.DataCase, async: true

  alias BlogApi.Blogs.{Blog, BlogsRepository}
  alias BlogApi.Users.UsersRepository

  describe "create/1" do
    setup do
      {:ok, %{id: id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      on_exit(fn ->
        nil
      end)

      {:ok, %{user_id: id}}
    end

    test "should create a blog", %{user_id: user_id} do
      %{name: name, description: description} =
        attrs = %{user_id: user_id, name: "Jurema's blog", description: "that's it!"}

      assert {:ok,
              %Blog{
                id: _id,
                user_id: ^user_id,
                name: ^name,
                description: ^description
              }} = BlogsRepository.create(attrs)
    end
  end

  describe "update/2" do
    setup do
      {:ok, %{id: id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      on_exit(fn ->
        nil
      end)

      {:ok, %{user_id: id}}
    end

    test "should update a blog", %{user_id: user_id} do
      {:ok, %{id: id} = blog} =
        BlogsRepository.create(%{
          user_id: user_id,
          name: "Jurema's blog",
          description: "that's it!"
        })

      %{name: name, description: description} =
        updated_attrs = %{name: "Goku's blog", description: "not's it"}

      assert {:ok, %{id: ^id, name: ^name, description: ^description}} =
               BlogsRepository.update(blog, updated_attrs)
    end
  end

  describe "get_all/0" do
    setup do
      {:ok, %{id: id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      on_exit(fn ->
        nil
      end)

      {:ok, %{user_id: id}}
    end

    test "should return all blogs", %{user_id: user_id} do
      %{user_id: user_id, name: "Jurema's blog", description: "that's it!"}
      |> BlogsRepository.create()

      assert length(BlogsRepository.get_all()) == 1
    end
  end

  describe "get/1" do
    setup do
      {:ok, %{id: id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      on_exit(fn ->
        nil
      end)

      {:ok, %{user_id: id}}
    end

    test "should return a blog", %{user_id: user_id} do
      {:ok, %{id: id, name: name, description: description}} =
        %{user_id: user_id, name: "Jurema's blog", description: "that's it!"}
        |> BlogsRepository.create()

      assert {:ok,
              %Blog{
                id: ^id,
                name: ^name,
                description: ^description
              }} = BlogsRepository.get(id)
    end
  end

  describe "delete/1" do
    setup do
      {:ok, %{id: id}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      on_exit(fn ->
        nil
      end)

      {:ok, %{user_id: id}}
    end

    test "should delete a blog", %{user_id: user_id} do
      {:ok, %{id: id}} =
        %{user_id: user_id, name: "Jurema's blog", description: "that's it!"}
        |> BlogsRepository.create()

      assert BlogsRepository.delete(id)
      assert {:ok, nil} = BlogsRepository.get(id)
    end
  end
end
