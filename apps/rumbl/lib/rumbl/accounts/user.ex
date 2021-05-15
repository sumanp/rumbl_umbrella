defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset #Ecto.Changeset defines cast, validate_required, and vali- date_length

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true # exists only in the struct, not database
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, attrs) do #you’ll use one changeset per use case
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username]) #returns an Ecto.Changeset
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
      _ -> # If the changeset is invalid, we simply return it to the caller
        changeset
    end
  end


  # The schema and field macros let us spec- ify both the underlying database table and the Elixir struct at the same time.
end

# The controller shouldn’t care about these short persistence details, but neither should the schema.
# We isolate change policy to a single place.
