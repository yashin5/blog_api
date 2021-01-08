defmodule Users.UsersRepositoryTest do
  use BlogApi.DataCase, async: true
  import Mox

  alias BlogApi.Users.UsersRepository

  setup :verify_on_exit!

  doctest BlogApi.Users.UsersRepository

  describe "new_user/3" do
    test "Should create a new user if pass correct params" do
      {:ok, %{email: email} = user} =
        UsersRepository.new_user("regular", "Yaxx", "onshura@gmailsx.com", "X@ghnx1234")

      user_simulate = %{
        email: email,
        id: user.id,
        name: "Yaxx",
        password_hash: user.password_hash
      }

      user_struct = %{
        email: user.email,
        id: user.id,
        name: user.name,
        password_hash: user.password_hash
      }

      assert user_simulate == user_struct
    end

    test "Should not be able to create a new user if password dont match the minimum requiriments" do
      {:error, message} =
        UsersRepository.new_user("regular", "Yaxx", "sowaka@gmailsx.com", "Xghnx1234")

      error = [password: {"Password does not match the minimun requirements", []}]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid email" do
      {:error, message} = UsersRepository.new_user("regular", "Yaxx", "yaxx.com", "X@ghnx1234")

      error = [{:email, {"has invalid format", [validation: :format]}}]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid email type" do
      {:error, message} = UsersRepository.new_user("regular", "Yaxx", 11, "X@ghnx1234")

      error = [{:email, {"is invalid", [type: :string, validation: :cast]}}]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid name" do
      {:error, message} = UsersRepository.new_user("regular", "Y", "yaxx@g.com", "X@ghnx1234")

      error = [
        {:name,
         {"should be at least %{count} character(s)",
          [count: 2, validation: :length, kind: :min, type: :string]}}
      ]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid name type" do
      {:error, message} = UsersRepository.new_user("regular", 12, "yaxx@g.com", "X@ghnx1234")

      error = [{:name, {"is invalid", [type: :string, validation: :cast]}}]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid password" do
      {:error, message} = UsersRepository.new_user("regular", "Yaxx", "yaxx@g.com", "X@23")

      error = [
        {:password,
         {"should be at least %{count} character(s)",
          [count: 6, validation: :length, kind: :min, type: :string]}}
      ]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid password type" do
      {:error, message} = UsersRepository.new_user("regular", "Yaxx", "yaxx@g.com", 1)

      error = [password: {"is invalid", [type: :string, validation: :cast]}]

      assert message.errors == error
    end

    test "Should not create a new user if pass a invalid password length" do
      {:error, message} = UsersRepository.new_user("regular", "Yaxx", "yaxx@g.com", "X@")

      error = [
        {:password,
         {"should be at least %{count} character(s)",
          [count: 6, validation: :length, kind: :min, type: :string]}}
      ]

      assert message.errors == error
    end
  end

  describe "authenticate/2" do
    test "Should be able to authenticate if pass data from existent user" do
      {:ok, %{email: email}} =
        UsersRepository.new_user("regular", "Yaxx", "biroliro@gmailsx.com", "X@ghnx1234")

      {:ok, authenticate} =
        UsersRepository.authenticate(%{"email" => email, "password" => "X@ghnx1234"})

      token_length = authenticate |> String.length()
      supose_to_be_length = 64

      assert token_length == supose_to_be_length
    end

    test "Should not be able to authenticate if pass data from unexistent user" do
      {:error, message} =
        UsersRepository.authenticate(%{
          "email" => "luladrao@gmailsx.com",
          "password" => "X@ghnx1234"
        })

      error = :user_dont_exist

      assert ^message = error
    end

    test "Should not be able to authenticate if pass invalid email type" do
      {:error, message} =
        UsersRepository.authenticate(%{"email" => 1, "password" => "X@ghnx1234"})

      error = :invalid_email_type

      assert ^message = error
    end

    test "Should not be able to authenticate if pass invalid password type" do
      {:error, message} =
        UsersRepository.authenticate(%{"email" => "yaxx@g.xom", "password" => 1})

      error = :invalid_password_type

      assert ^message = error
    end
  end

  describe "get_user/1" do
    test "Should be able to get user informations if pass a existent user email" do
      {:ok, %{email: email}} =
        UsersRepository.new_user("regular", "Yaxx", "choranao@gmailsx.com", "X@ghnx1234")

      {:ok, user} = UsersRepository.get_user(%{email: email})

      user_simulate = %{
        email: email,
        id: user.id,
        name: "Yaxx",
        password_hash: user.password_hash
      }

      user_struct = %{
        email: user.email,
        id: user.id,
        name: user.name,
        password_hash: user.password_hash
      }

      assert user_simulate == user_struct
    end

    test "Should not be able to get user informations if pass a unexistent user email" do
      {:error, message} = UsersRepository.get_user(%{email: "bebe@gmailsx.comm"})
      error = :user_dont_exist

      assert ^message = error
    end

    test "Should not be able to get user informations if pass a invalid email type" do
      {:error, message} = UsersRepository.get_user(%{email: 1})

      error = :invalid_email_type

      assert ^message = error
    end

    test "Should be able to get user informations if pass a existent id of user" do
      {:ok, %{id: id, email: email, name: name}} =
        UsersRepository.new_user("regular", "Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, user} = UsersRepository.get_user(%{user_id: id})

      user_simulate = %{
        email: email,
        id: id,
        name: name,
        password_hash: user.password_hash
      }

      user_struct = %{
        email: user.email,
        id: id,
        name: name,
        password_hash: user.password_hash
      }

      assert user_simulate == user_struct
    end

    test "Should not be able to get user informations if pass a unexistent id" do
      {:error, message} = UsersRepository.get_user(%{user_id: Ecto.UUID.generate()})
      error = :user_dont_exist

      assert ^message = error
    end

    test "Should not be able to get user informations if pass a invalid id type" do
      {:error, message} = UsersRepository.get_user(%{user_id: 123})
      error = :invalid_id_type

      assert ^message = error
    end
  end
end
