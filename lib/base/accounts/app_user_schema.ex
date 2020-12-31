defmodule App.Base.Account.AppUser do
  @moduledoc """
  Schema for app user
  """

  use Ecto.Schema
  use Arc.Ecto.Schema

  # Need refactor
  alias App.Person.Person
  alias App.Family.Family

  import Argon2, only: [add_hash: 1]
  import Ecto.Changeset

  @allow_fields [
    :email,
    :password,
    :role,
    :access_token,
    :enabled,
    :name,
    :user_id,
    :family_id,
    :person_id
  ]

  schema "app_users" do
    field(:email, :string, null: false)
    field(:access_token, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:name, :string)
    field(:enabled, :boolean, default: true)
    field(:role, :string, default: "app-user")

    belongs_to(:person, Person)
    belongs_to(:family, Family)
    belongs_to(:user, User)

    timestamps()
  end

  def changeset(%__MODULE__{} = model, attrs) do
    IO.puts "======================"
    IO.inspect attrs
    IO.puts "======================"
    model
    |> cast(attrs, @allow_fields)
    |> validate_required([:email, :role])
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
    |> unique_constraint(:email)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:family_id)
    |> foreign_key_constraint(:person_id)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, add_hash(password))
  end

  def appuser_role do
    "app-user"
  end
end
