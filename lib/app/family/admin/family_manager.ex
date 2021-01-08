defmodule App.Family.Admin.FamilyManager do
  @moduledoc """
  family manager
  """
  alias App.Repo
  alias App.Family.Family

  import Ecto.Query, only: [from: 2]

  def load_family(current_admin, id) do
    from(
      f in Family,
      where: f.id == ^id,
      where: is_nil(f.deleted_at),
    ) |> Repo.one()
  end

  def create_new_family(current_admin, params) do
    Family.changeset(
      %Family{},
      Map.merge(
        params,
        %{
          "owner_id" => current_admin.id
        }
      )
    )
    |> Repo.insert()
  end

  def update_family(id, params) do
    family = Family |> Repo.get(id)

    if family do
      family |> Family.changeset(params) |> Repo.update()
    else
      {:error, %{message: :not_found}}
    end
  end

  def remove_family(id) do
    family = Family |> Repo.get(id)

    if family do
      family |> Family.delete_changeset() |> Repo.update()
    else
      {:error, %{message: :not_found}}
    end
  end

  def list_families_of_an_owner(current_admin, params) do
    query = from(
      f in Family,
      where: f.owner_id == ^current_admin.id,
      where: is_nil(f.deleted_at)
    )
    count = query |> Repo.aggregate(:count, :id)
    records = query
    |> Repo.paginate(params)
    %{ count: count, records: records }
  end
end
