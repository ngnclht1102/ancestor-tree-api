defmodule App.Family.FamilyAdminManager do
  @moduledoc """
  family manager
  """
  alias App.Repo
  alias App.Family.Family

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

  def load_ do
  end
end
