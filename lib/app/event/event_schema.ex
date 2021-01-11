defmodule App.Event.Event do
  @moduledoc """
  Schema for event
  """
  use Ecto.Schema

  import Ecto.Changeset
  alias App.Family.Family
  alias App.Base.Account.{AdminUser}

  @allow_fields [
    :name,
    :description,
    :dt_in_lunar,
    :dt_date,
    :dt_month,
    :dt_year,
    :time,
    :repeat,
    :repeat_times,
    :repeat_type,
    :owner_id,
    :family_id
  ]

  schema "events" do
    field(:name, :string)
    field(:description, :string)
    field(:dt_in_lunar, :boolean)
    field(:dt_date, :integer)
    field(:dt_month, :integer)
    field(:dt_year, :integer)
    field(:time, :time)
    field(:deleted_at, :naive_datetime)
    field(:repeat, :boolean)
    field(:repeat_times, :integer)
    field(:repeat_type, :string)

    timestamps()

    belongs_to(:created_by, AdminUser)
    belongs_to(:family, Family)
  end

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @allow_fields)
    |> validate_required([:name, :dt_date, :dt_month])
    |> validate_inclusion(:repeat_type, ["", repeate_type_none(), repeate_type_yearly()])
    |> validate_repeat_changeset()
    |> foreign_key_constraint(:created_by_id)
    |> foreign_key_constraint(:family_id)
  end

  def validate_repeat_changeset(
    %Ecto.Changeset{
      valid?: true,
      changes: %{ repeat_type: repeat_type }
    } = changeset
  ) when repeat_type == "no-repeat" do
    changeset |> validate_required([:dt_year])
  end

  def validate_repeat_changeset(changeset) do
    changeset
  end

  def delete_changeset(%__MODULE__{} = model) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    model
    |> change()
    |> put_change(:deleted_at, now)
  end

  def repeate_type_none(), do: "no-repeat"
  def repeate_type_yearly(), do: "repeat-yearly"
end
