defmodule App.Family.Family do
  @moduledoc """
  Schema for family
  """
  use Ecto.Schema

  import Ecto.Changeset
  alias App.Base.Account.{AdminUser}

  @allow_fields [
    :name,
    :main_address,
    :description
  ]

  schema "families" do
    field(:name, :string)
    field(:main_address, :string)
    field(:description, :string)

    timestamps()

    belongs_to(:owner, AdminUser)
  end

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @allow_fields)
    |> validate_required([:name, :main_address])
    |> validate_length(:name, min: 3)
    |> foreign_key_constraint(:owner_id)
  end
end
