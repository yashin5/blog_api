defmodule BlogApi.Tokens.Token do
  @moduledoc """
  Schema to table Token
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias BlogApi.Users.User

  @type t :: %__MODULE__{
          id: String.t()
        }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "tokens" do
    field(:token, :string)

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset_insert(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end

  def changeset_update(accounts, %{} = params) do
    accounts
    |> cast(params, [:updated_at])
    |> validate_required([:updated_at])
  end
end
