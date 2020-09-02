defmodule App.Person.Admin.PersonManager do
  @moduledoc """
  person manager
  """
  alias App.Repo
  alias App.Person.Person

  import Ecto.Query, only: [from: 2]

  def create_new_person(current_admin, params) do
    Person.changeset(
      %Person{},
      Map.merge(
        params,
        %{
          "created_by_id" => current_admin.id
        }
      )
    )
    |> Repo.insert()
  end

  def update_person(_current_admin, id, params) do
    person = Person |> Repo.get(id)

    if person do
      Person.changeset(
        person,
        params
      )
      |> Repo.update()
    else
      {:error, [:person_not_found]}
    end
  end

  def list_person_of_given_family(current_family, params) do
    from(
      p in Person,
      where: is_nil(p.deleted_at),
      where: p.family_id == ^current_family.id
    )
    |> Repo.paginate(params)
  end

  def remove_person(id) do
    person = Person |> Repo.get(id)

    if person do
      Person.delete_changeset(person)
      |> Repo.update()
    else
      {:error, [:person_not_found]}
    end
  end
end
