defmodule Blogs.BlogsRepositoryTest do
  use BlogApi.DataCase, async: true

  alias BlogApi.Blogs.{Blog, BlogsRepository}

  describe "create/1" do
    test "should create a blog" do
      %{name: name, description: description} =
        attrs = %{name: "Jurema's blog", description: "that's it!"}

      assert {:ok,
              %Blog{
                id: _id,
                name: ^name,
                description: ^description
              }} = BlogsRepository.create(attrs)
    end
  end

  describe "update/2" do
    test "should update a blog" do
      {:ok, %{id: id} = blog} =
        BlogsRepository.create(%{name: "Jurema's blog", description: "that's it!"})

      %{name: name, description: description} =
        updated_attrs = %{name: "Goku's blog", description: "not's it"}

      assert {:ok, %{id: ^id, name: ^name, description: ^description}} =
               BlogsRepository.update(blog, updated_attrs)
    end
  end

  describe "get_all/0" do
    test "should return all blogs" do
      %{name: "Jurema's blog", description: "that's it!"}
      |> BlogsRepository.create()

      assert length(BlogsRepository.get_all()) == 1
    end
  end

  describe "get/1" do
    test "should return a blog" do
      {:ok, %{id: id, name: name, description: description}} =
        %{name: "Jurema's blog", description: "that's it!"}
        |> BlogsRepository.create()

      assert %Blog{
               id: ^id,
               name: ^name,
               description: ^description
             } = BlogsRepository.get(id)
    end
  end

  describe "delete/1" do
    test "should delete a blog" do
      {:ok, %{id: id}} =
        %{name: "Jurema's blog", description: "that's it!"}
        |> BlogsRepository.create()

      assert BlogsRepository.delete(id)
      assert is_nil(BlogsRepository.get(id))
    end
  end
end
