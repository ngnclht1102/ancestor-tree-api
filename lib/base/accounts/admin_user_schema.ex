defmodule App.Base.Account.AdminUser do
  @moduledoc """
  Schema for Admin portal user
  """
  use Ecto.Schema

  import Argon2, only: [add_hash: 1]
  import Ecto.Changeset
  alias Tfw.Account.User

  @allow_fields [
    :email,
    :password,
    :role,
    :created_by_id,
    :access_token,
    :enabled,
    :name,
    :user_id
  ]

  schema "admin_users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:name, :string)
    field(:access_token, :string)
    field(:role, :string, default: "admin_lv1")
    field(:enabled, :boolean, default: true)

    timestamps()

    belongs_to(:created_by, __MODULE__)
    belongs_to(:user, User)
  end

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @allow_fields)
    |> validate_required([:email, :role])
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
    |> unique_constraint(:email)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:created_by_id)
  end

  def disable_changeset(%__MODULE__{} = model) do
    model
    |> change()
    |> put_change(:enabled, false)
  end

  def enable_changeset(%__MODULE__{} = model) do
    model
    |> change()
    |> put_change(:enabled, true)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
