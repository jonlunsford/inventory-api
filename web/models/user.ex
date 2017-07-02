defmodule Inventory.User do
  use Inventory.Web, :model

  alias Inventory.User
  alias Inventory.Repo

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :companies, Inventory.Company, on_delete: :delete_all, foreign_key: :owner_id
    has_many :messags, Inventory.Message
    belongs_to :room, Inventory.Room

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:email)
  end

  @doc """
  Finds a user and verifies the correct password
  """
  def find_and_confirm_password(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case authenticate(user, password) do
      true -> {:ok, user}
      _    -> {:error, "Email or password is invalid"}
    end
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashed = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashed)
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end
end
