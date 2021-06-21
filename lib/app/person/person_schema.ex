defmodule App.Person.Person do
  @moduledoc """
  Schema for person
  """

  use Ecto.Schema
  use Arc.Ecto.Schema

  alias App.Family.Family
  alias App.Repo
  alias App.Base.Ext.Utils.StringUtils

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
    :is_alive,
    :sibling_level,
    :family_level,
    :note,
    :father_id,
    :mother_id,
    :spouse_id,
    :family_id,
    :address,
    :phone_number,
    :tomb_address,
    :belong_to_main_list_of_family
  ]

  schema "persons" do
    field(:full_name, :string)
    field(:nickname, :string)
    field(:gender, :string)
    field(:address, :string)
    field(:phone_number, :string)
    field(:tomb_address, :string)
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
    field(:is_alive, :boolean)
    field(:is_root, :boolean)
    field(:deleted_at, :naive_datetime)

    field(:ascii_nickname, :string)
    field(:ascii_full_name, :string)
    field(:ascii_address, :string)
    field(:ascii_tomb_address, :string)
    field(:ascii_note, :string)

    field(:belong_to_main_list_of_family, :boolean)

    belongs_to(:father, __MODULE__)
    belongs_to(:mother, __MODULE__)
    belongs_to(:spouse, __MODULE__)
    belongs_to(:family, Family)

    timestamps()
  end

  def changeset(%__MODULE__{} = person, attrs) do
    person
    |> cast(attrs, @allow_fields)
    |> validate_required([:family_id, :full_name])
    |> validate_changeset(person)
    |> set_family_level()
  end

  def family_level_changeset(%__MODULE__{} = person, new_level) do
    person
    |> change()
    |> put_change(:family_level, new_level)
  end

  def delete_changeset(%__MODULE__{} = person) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    person
    |> change()
    |> put_change(:deleted_at, now)
  end

  defp validate_changeset(changeset, _person) do
    changeset
    |> validate_number(:dob_date, greater_than: 0, less_than: 31)
    |> validate_number(:dob_month, greater_than: 0, less_than: 13)
    |> validate_number(:dob_year, greater_than: 0)
    |> validate_number(:dod_date, greater_than: 0, less_than: 31)
    |> validate_number(:dod_month, greater_than: 0, less_than: 13)
    |> validate_number(:dod_year, greater_than: 0)
    |> update_change(:gender, &String.downcase/1)
    |> validate_inclusion(:gender, ~w(male female others))
    |> foreign_key_constraint(:father_id)
    |> foreign_key_constraint(:mother_id)
    |> foreign_key_constraint(:spouse_id)
    |> update_for_search
  end

  defp update_for_search(changeset) do
    ascii_nickname = get_field(changeset, :nickname) |> StringUtils.vietnamese_to_ascii()
    ascii_full_name = get_field(changeset, :full_name) |> StringUtils.vietnamese_to_ascii()
    ascii_address = get_field(changeset, :address) |> StringUtils.vietnamese_to_ascii()
    ascii_tomb_address = get_field(changeset, :tomb_address) |> StringUtils.vietnamese_to_ascii()
    ascii_note = get_field(changeset, :note) |> StringUtils.vietnamese_to_ascii()

    changeset
    |> put_change(:ascii_nickname, ascii_nickname)
    |> put_change(:ascii_full_name, ascii_full_name)
    |> put_change(:ascii_address, ascii_address)
    |> put_change(:ascii_tomb_address, ascii_tomb_address)
    |> put_change(:ascii_note, ascii_note)
  end

  def set_family_level(changeset) do
    father_id = changeset |> get_field(:father_id)
    spouse_id = changeset |> get_field(:spouse_id)

    if father_id do
      father = __MODULE__ |> Repo.get(father_id)

      father_family_level =
        if is_nil(father.family_level) do
          father |> __MODULE__.family_level_changeset(1) |> Repo.update()
          1
        else
          father.family_level
        end

      if father do
        changeset |> put_change(:family_level, father_family_level + 1)
      else
        spouse_id |> get_family_level_from_spouse(changeset)
      end
    else
      spouse_id |> get_family_level_from_spouse(changeset)
    end
  end

  defp get_family_level_from_spouse(spouse_id, changeset) do
    if not is_nil(spouse_id) do
      spouse =
        __MODULE__
        |> Repo.get(spouse_id)

      if spouse do
        changeset |> put_change(:family_level, spouse.family_level)
      else
        changeset |> put_change(:family_level, nil)
      end
    else
      changeset |> put_change(:family_level, nil)
    end
  end
end
