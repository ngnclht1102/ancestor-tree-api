defmodule App.Person.Admin.PersonManager do
  @moduledoc """
  person manager
  """
  alias App.Repo
  alias App.Person.Person

  import Ecto.Query, only: [from: 2]

  def create_new_person(current_family, current_admin, params) do
    Person.changeset(
      %Person{},
      Map.merge(
        params,
        %{
          "created_by_id" => current_admin.id,
          "family_id" => current_family.id
        }
      )
    )
    |> Repo.insert()
    |> update_spouse_id_for_partner
  end

  # TODO: fix the query
  # both wife and husband need to have spouse id, so need to update the partner
  # case: if set a wrong spouse, so we need to make changes, first, we need to clear all
  def update_spouse_id_for_partner(result) do
    with {:ok, person} <- result,
         true <- not is_nil(person.spouse_id) do
      # remove links
      old_spouse_ids =
        from(
          u in Person,
          where: u.spouse_id == ^person.id,
          where: u.id != ^person.spouse_id
        )
        |> Repo.all
        |> Enum.map(fn x -> x.id end)
      from(
        u in Person,
        where: u.id in ^old_spouse_ids
      )
      |> Repo.update_all(set: [ spouse_id: nil ])

      Person
      |> Repo.get(person.spouse_id)
      |> Person.changeset(%{spouse_id: person.id})
      |> Repo.update()
    end

    result
  end

  def update_person(_current_admin, id, params) do
    person = Person |> Repo.get(id)

    if person do
      Person.changeset(
        person,
        params
      )
      |> Repo.update()
      |> update_spouse_id_for_partner
    else
      {:error, [:person_not_found]}
    end
  end

  def list_person_of_given_family(current_family, params) do
    query =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.family_id == ^current_family.id
      )

    records = query |> Repo.paginate(params)
    count = query |> Repo.aggregate(:count, :id)
    %{count: count, records: records}
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

  def load_person(id) do
    Person |> Repo.get(id)
  end

  def load_tree_of_family(current_family) do
    query =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.family_id == ^current_family.id,
        where: p.is_root == true,
        limit: 1
      )

    root = query |> Repo.one() |> Repo.preload(:spouse)
    first_childrens = load_first_level_children_of(root, current_family)
    %{root: root, children: first_childrens}
  end

  def load_tree_of_family(from_person_id, current_family) do
    query =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.family_id == ^current_family.id,
        where: p.id == ^from_person_id,
        limit: 1
      )

    root = query |> Repo.one() |> Repo.preload(:spouse)
    first_childrens = load_first_level_children_of(root, current_family)
    %{root: root, children: first_childrens}
  end

  def load_first_level_children_of(person, current_family) do
    first_level_query =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.family_id == ^current_family.id,
        where: p.father_id == ^person.id
      )

    first_level_query
    |> Repo.all()
    |> Repo.preload(:spouse)
  end
end
