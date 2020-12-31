defmodule App.Base.Account.Session do
  @moduledoc """
  Schema for session
  """

  use Ecto.Schema

  alias App.Base.Account.{User, AdminUser, AppUser}

  import Ecto.Changeset

  @allow_fields [
    :email,
    :phone_number,
    :firebase_id,
    :user_id,
    :admin_user_id
  ]

  schema "sessions" do
    field(:email, :string)
    field(:phone_number, :string)
    field(:firebase_id, :string)
    field(:deleted_at, :naive_datetime)

    timestamps()

    belongs_to(:user, User)
    belongs_to(:admin_user, AdminUser)
    belongs_to(:app_user, AppUser)
  end

  def changeset(%__MODULE__{} = session, attrs) do
    session
    |> cast(attrs, @allow_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:admin_user_id)
    |> unique_constraint(:phone_number)
    |> unique_constraint(:email)
  end

  def delete_changeset(%__MODULE__{} = model) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    model
    |> change()
    |> put_change(:deleted_at, now)
  end
end
