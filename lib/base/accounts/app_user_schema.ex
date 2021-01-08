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
    :person_id,
    :deleted_at
  ]

  schema "app_users" do
    field(:email, :string, null: false)
    field(:access_token, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:name, :string)
    field(:enabled, :boolean, default: true)
    field(:role, :string, default: "app-user")
    field(:deleted_at, :naive_datetime)

    belongs_to(:person, Person)
    belongs_to(:family, Family)
    belongs_to(:user, User)

    timestamps()
  end

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @allow_fields)
    |> validate_required([:email, :role])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
    |> unique_constraint(:email)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:family_id)
    |> foreign_key_constraint(:person_id)
  end

  def admin_delete_changeset(%__MODULE__{} = model) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    model
    |> change()
    |> put_change(:deleted_at, now)
  end

  def admin_update_changeset(%__MODULE__{} = model, attrs) do
    changset = model
    |> cast(attrs, @allow_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:family_id)
    |> foreign_key_constraint(:person_id)
    case Map.fetch(attrs, :password) do
      {:ok, _password} -> changset |> admin_update_password_changeset(attrs)
      _ -> changset
    end
  end

  def admin_update_password_changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
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
