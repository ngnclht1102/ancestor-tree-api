defmodule App.Family.Admin.FamilyManager do
  @moduledoc """
  family manager
  """
  alias App.Repo
  alias App.Family.Family

  import Ecto.Query, only: [from: 2]

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

  def list_families_of_an_owner(current_admin, params) do
    from(
      f in Family,
      where: f.owner_id == ^current_admin.id
    )
    |> Repo.paginate(params)
  end
end
