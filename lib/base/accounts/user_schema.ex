defmodule App.Base.Account.User do
  @moduledoc """
  Schema for user
  """

  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  @allow_fields [
    :first_name,
    :last_name,
    :email,
    :phone_country_code,
    :phone_number_without_code,
    :nickname,
    :dob_month,
    :dob_year,
    :access_token,
    :state,
    :gender,
    :type
  ]

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string, null: false)
    field(:phone_country_code, :string)
    field(:phone_number_without_code, :string)
    field(:nickname, :string)
    field(:dob_month, :integer)
    field(:dob_year, :integer)
    field(:access_token, :string)
    field(:state, :string)
    field(:gender, :string)
    field(:type, :string)

    timestamps()
  end

  def create_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @allow_fields)
    |> validate_required([:email])
    |> validate_changeset(user)
  end

  defp validate_changeset(changeset, _user) do
    changeset
    |> validate_number(:dob_month, greater_than: 0, less_than: 13)
    |> validate_number(:dob_year, greater_than: 0)
    |> validate_format(:phone_country_code, ~r/^\+\d{1,3}/)
    |> update_change(:gender, &String.downcase/1)
    |> validate_inclusion(:gender, ~w(male female others))
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> update_change(:nickname, &String.trim/1)
    |> unique_constraint(:email)
    |> unique_constraint(:access_token)
    |> unique_constraint(:phone_number_without_code,
      name: :users_country_code_phone_number_without_code_index
    )
  end
end
