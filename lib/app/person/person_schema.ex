defmodule App.Person.Person do
  @moduledoc """
  Schema for user
  """

  use Ecto.Schema
  use Arc.Ecto.Schema

  alias App.Family.Family

  import Ecto.Changeset

  @allow_fields [
    :full_name,
    :nickname,
    :dob_date,
    :dob_month,
    :dob_year,
    :dob_in_lunar,
    :dod_date,
    :dod_month,
    :dod_year,
    :dod_in_lunar,
    :gender,
    :is_dead,
    :sibling_level,
    :family_level,
    :note,
    :is_root,
    :father_id,
    :mother_id,
    :spouse_id,
    :family_id
  ]

  schema "persons" do
    field(:full_name, :string)
    field(:nickname, :string)
    field(:gender, :string)
    field(:family_level, :integer)
    field(:sibling_level, :integer)
    field(:note, :string)
    field(:dob_date, :integer)
    field(:dob_month, :integer)
    field(:dob_year, :integer)
    field(:dob_in_lunar, :boolean)
    field(:dod_date, :integer)
    field(:dod_month, :integer)
    field(:dod_year, :integer)
    field(:dod_in_lunar, :boolean)
    field(:is_dead, :boolean)
    field(:is_root, :boolean)
    field(:deleted_at, :naive_datetime)

    belongs_to(:father, __MODULE__)
    belongs_to(:mother, __MODULE__)
    belongs_to(:spouse, __MODULE__)
    belongs_to(:family, Family)

    timestamps()
  end

  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @allow_fields)
    |> validate_required([:family_id, :full_name])
    |> validate_changeset(user)
  end

  def delete_changeset(%__MODULE__{} = user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    user
    |> change()
    |> put_change(:deleted_at, now)
  end

  defp validate_changeset(changeset, user) do
    changeset
    |> validate_number(:dob_date, greater_than: 0, less_than: 31)
    |> validate_number(:dob_month, greater_than: 0, less_than: 13)
    |> validate_number(:dob_year, greater_than: 0)
    |> validate_number(:dod_date, greater_than: 0, less_than: 31)
    |> validate_number(:dod_month, greater_than: 0, less_than: 13)
    |> validate_number(:dod_year, greater_than: 0)
    |> update_change(:gender, &String.downcase/1)
    |> validate_inclusion(:gender, ~w(male female others))
    |> update_change(:nickname, &String.trim/1)
    |> foreign_key_constraint(:father_id)
    |> foreign_key_constraint(:mother_id)
    |> foreign_key_constraint(:spouse_id)
  end
end
