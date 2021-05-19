defmodule AppWeb.Admin.V1.PersonView do
  use AppWeb, :view

  def render("show.json", %{item: item}) do
    %{
      data: render_one(item, __MODULE__, "person.json", as: :item)
    }
  end

  def render("spouse_in_tree.json", %{item: item}) do
    %{
      id: item.id,
      name: item.full_name,
      full_name: item.full_name,
      nickname: item.nickname
    }
  end

  def render("person.json", %{item: item}) do
    %{
      id: item.id,
      name: item.full_name,
      full_name: item.full_name,
      nickname: item.nickname,
      gender: item.gender,
      family_level: item.family_level,
      sibling_level: item.sibling_level,
      note: item.note,
      dob_date: item.dob_date,
      dob_month: item.dob_month,
      dob_year: item.dob_year,
      dob_in_lunar: item.dob_in_lunar,
      dod_date: item.dod_date,
      dod_month: item.dod_month,
      dod_year: item.dod_year,
      dod_in_lunar: item.dod_in_lunar,
      is_alive: item.is_alive,
      is_root: item.is_root,
      family_id: item.family_id,
      father_id: item.father_id,
      mother_id: item.mother_id,
      spouse_id: item.spouse_id,
      deleted_at: item.deleted_at,
      address: item.address,
      phone_number: item.phone_number,
      tomb_address: item.tomb_address,
      ascii_full_name: item.ascii_full_name
    }
  end

  def render("person_in_tree.json", %{item: item}) do
    %{
      id: item.id,
      name: item.full_name,
      full_name: item.full_name,
      nickname: item.nickname,
      gender: item.gender,
      sibling_level: item.sibling_level,
      spouse:
        item.spouse_id && render_one(item.spouse, __MODULE__, "spouse_in_tree.json", as: :item)
    }
  end

  def render("index.json", %{items: items}) do
    %{
      data: render_many(items, __MODULE__, "person.json", as: :item)
    }
  end

  def render("tree.json", %{root: root, children: children}) do
    %{
      data:
        Map.merge(
          %{
            children:
              Enum.reduce(children, %{}, fn item, acc ->
                Map.put(
                  acc,
                  "child_#{item.id}",
                  render_one(item, __MODULE__, "person_in_tree.json", as: :item)
                )
              end)
          },
          render_one(root, __MODULE__, "person_in_tree.json", as: :item)
        )
    }
  end
end
