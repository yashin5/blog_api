defmodule BlogApi.Tokens.TokenRepository do
  @moduledoc """
    This module is responsable to generate, validate and renew the token.
  """
  import Ecto.Query, only: [where: 3, last: 2, select: 2]

  alias BlogApi.Repo
  alias BlogApi.Tokens.Token
  alias BlogApi.Users.UserRepository

  @doc """
  Generate a token

  ## Examples
      BlogApi.Tokens.TokenRepository.generate_token(account.id)
  """
  @spec generate_token(String.t()) :: {:ok, String.t()} | {:error, atom()}
  def generate_token(id) do
    with {:ok, user} <- UserRepository.get_user(%{user_id: id}),
         {:ok, new_token} <- do_generate_token() do
      {_, token} =
        user
        |> Ecto.build_assoc(:tokens, new_token)
        |> Token.changeset_insert()
        |> Repo.insert()

      {:ok, token.token}
    end
  end

  defp do_generate_token do
    length = 64

    token = %{
      token:
        length
        |> :crypto.strong_rand_bytes()
        |> Base.encode64()
        |> binary_part(0, length)
    }

    {:ok, token}
  end

  @doc """
  Validate the token

  ## Examples
      BlogApi.Tokens.TokenRepository.validate_token(%{"token" => token})
  """
  @callback validate_token(String.t()) :: {:ok, String.t()} | {:error, atom()}
  def validate_token(%{"token" => token}) when is_binary(token) do
    Token
    |> where([token], token.token == ^token)
    |> last(:inserted_at)
    |> Repo.one()
    |> do_validate_token()
  end

  def validate_token(_), do: {:error, :invalid_token_type}

  defp do_validate_token(nil), do: {:error, :token_dont_exist}

  defp do_validate_token(token) do
    date = DateTime.utc_now()

    {_, time_now} =
      NaiveDateTime.new(date.year, date.month, date.day, date.hour, date.minute, date.second)

    season_duration = 300

    time_now
    |> NaiveDateTime.diff(token.updated_at)
    |> Kernel.<=(season_duration)
    |> renew_token(token, time_now)
  end

  defp renew_token(true, token, time_now) do
    token
    |> Token.changeset_update(%{updated_at: time_now})
    |> Repo.update()

    {:ok, token.user_id}
  end

  defp renew_token(false, _, _), do: {:error, :season_expired}
end
