defmodule App.Person.Admin.PersonManager do
  @moduledoc """
  person manager
  """
  alias App.Repo
  alias App.Person.Person
  alias App.Family.Family

  import Ecto.Query, only: [from: 2]

  def create_new_person(current_admin, params) do
    Person.create_changeset(
      %Person{},
      Map.merge(
        params,
        %{
          "created_by_id" => current_admin.id
        }
      )
    ) |> Repo.insert()
  end

  def update_person(current_admin, family_id, id, params) do

  end
end
