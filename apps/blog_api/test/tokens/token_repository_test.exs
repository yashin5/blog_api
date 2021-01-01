defmodule Tokens.TokenRepositoryTest do
  use BlogApi.DataCase, async: true

  alias BlogApi.Tokens.TokenRepository
  alias BlogApi.Users.UserRepository

  doctest BlogApi.Tokens.TokenRepository

  describe "generate_token/1" do
    test "Should be able to create a token for an existent user" do
      {:ok, user} =
        UserRepository.new_user(
          "regular",
          "Yxcaxx",
          "yaxx@gmailsx.com",
          "X@ghnx1234"
        )

      {:ok, token} = TokenRepository.generate_token(user.id)

      token_length = token |> String.length()

      expected_length = 64

      assert token_length == expected_length
    end

    test "Should not be able to create a token for an unexistent user" do
      {:error, message} = TokenRepository.generate_token(Ecto.UUID.generate())
      error = :user_dont_exist

      assert ^message = error
    end

    test "Should not be able to create a token if insert a invalid id type" do
      {:error, message} = TokenRepository.generate_token(12)

      error = :invalid_id_type

      assert ^message = error
    end
  end

  describe "validate_token/1" do
    test "Should be able to verify if token is valid if insert a valid token" do
      {:ok, user} =
        UserRepository.new_user(
          "regular",
          "Yxcaxx",
          "yasdxx@gmailsx.com",
          "X@ghnx1234"
        )

      {:ok, token} =
        UserRepository.authenticate(%{
          "email" => "yasdxx@gmailsx.com",
          "password" => "X@ghnx1234"
        })

      assert {:ok, user.id} == TokenRepository.validate_token(%{"token" => token})
    end

    test "Should not be able to verify if token is valid if insert a invalid token" do
      {:error, message} =
        TokenRepository.validate_token(%{
          "token" => "aasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasasdasadasdas"
        })

      error = :token_dont_exist

      assert ^message = error
    end

    test "Should not be able to verify if token is valid if insert a invalid token type" do
      {:error, message} = TokenRepository.validate_token(%{"token" => 123})
      error = :invalid_token_type

      assert ^message = error
    end
  end
end
