defmodule App.Person.Admin.PersonManager do
  @moduledoc """
  person manager
  """
  alias App.Repo
  alias App.Person.Person

  import Ecto.Query
  import Ecto.Changeset

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
        |> Repo.all()
        |> Enum.map(fn x -> x.id end)

      from(
        u in Person,
        where: u.id in ^old_spouse_ids
      )
      |> Repo.update_all(set: [spouse_id: nil])

      Person
      |> Repo.get(person.spouse_id)
      |> Person.changeset(%{spouse_id: person.id})
      |> Repo.update()
    end

    result
  end

  def update_person(_current_admin, id, params) do
    person = Person |> Repo.get(id) |> Repo.preload(:spouse)

    changeset =
      Person.changeset(
        person,
        params
      )

    current_level = person.family_level
    new_level = changeset |> get_field(:family_level)

    need_update_family_level =
      if new_level != current_level do
        rev_update_family_level_for_children(person, new_level)
      end

    if person do
      changeset
      |> Repo.update()
      |> update_spouse_id_for_partner
    else
      {:error, [:person_not_found]}
    end
  end

  defp rev_update_family_level_for_children(person, new_level) do
    if person.spouse do
      person.spouse |> Person.family_level_changeset(new_level) |> Repo.update()
    end

    person |> Person.family_level_changeset(new_level) |> Repo.update()

    children =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.father_id == ^person.id
      )
      |> Repo.all()
      |> Repo.preload(:spouse)
      |> Enum.map(fn x -> rev_update_family_level_for_children(x, new_level + 1) end)
  end

  def list_person_of_given_family(current_family, params) do
    filters = try do
      Poison.decode!(params["filter"])
    rescue
      _ -> %{}
    end
    query =
      from(
        p in Person,
        where: is_nil(p.deleted_at),
        where: p.family_id == ^current_family.id,
        order_by: [asc: p.family_level, asc: p.dob_year, asc: p.sibling_level]
      )

    query = if filters["q"] do
      ilike_query = "%#{filters["q"]}%"
      query
        |> where([q], ilike(q.ascii_full_name, ^ilike_query))
        # TODO: use dynamic to buidl query to avoid wrong result
        # |> where([q], ilike(q.ascii_nickname, ^ilike_query))
        # |> or_where([q], ilike(q.nickname, ^ilike_query))
        # |> or_where([q], ilike(q.full_name, ^ilike_query))
        # |> or_where([q], ilike(q.address, ^ilike_query))
        # |> or_where([q], ilike(q.tomb_address, ^ilike_query))
        # |> or_where([q], ilike(q.note, ^ilike_query))
        # |> or_where([q], ilike(q.ascii_full_name, ^ilike_query))
        # |> or_where([q], ilike(q.ascii_address, ^ilike_query))
        # |> or_where([q], ilike(q.ascii_tomb_address, ^ilike_query))
        # |> or_where([q], ilike(q.ascii_note, ^ilike_query))
        # |> or_where([q], ilike(q.phone_number, ^ilike_query))
    else
      query
    end

    query = if filters["dob_year"] do
      {dobYearInt, ""} = Integer.parse(filters["dob_year"])
      query
        |> where([q], q.dob_year == ^dobYearInt)
    else
      query
    end
    query = if not is_nil(filters["belong_to_main_list_of_family"])
      and filters["belong_to_main_list_of_family"] == false do
      query
        |> where([q], q.belong_to_main_list_of_family == false)
    else
      if not is_nil(filters["all_list"]) do
        # if client need to load full list
        query
      else
        # by default we don't load people not belong to the main list
        query
        |> where([q], q.belong_to_main_list_of_family == true)
      end
    end

    query = if not is_nil(filters["is_alive"]) do
      query
        |> where([q], q.is_alive == ^filters["is_alive"])
    else
      query
    end

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
        where: p.family_level == 1,
        where: p.family_id == ^current_family.id,
        where: p.gender == "male",
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
        where: p.father_id == ^person.id,
        order_by: [asc: p.sibling_level, asc: p.dob_year]
      )

    data = first_level_query
    |> Repo.all()
    |> Repo.preload(:spouse)
    Enum.map(data, fn people ->
      # this is for order the tree, if sibling_level is not defined, bring the person to the bottom
      sibling_level = if is_nil(people.sibling_level) do
        100 # 100 is enough to bring the people down
      else
        people.sibling_level
      end
      Map.merge(people, %{ sibling_level: sibling_level })
    end)
  end
end
