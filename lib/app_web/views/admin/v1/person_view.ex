defmodule AppWeb.Admin.V1.PersonView do
  use AppWeb, :view

  def render("show.json", %{item: item}) do
    %{
      data: render_one(item, __MODULE__, "person.json", as: :item)
    }
  end

  def render("person.json", %{item: item}) do
    %{
      id: item.id,
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
      is_dead: item.is_dead,
      is_root: item.is_root,
      family_id: item.family_id,
      father_id: item.father_id,
      mother_id: item.mother_id,
      spouse_id: item.spouse_id,
      deleted_at: item.deleted_at
    }
  end

  def render("index.json", %{items: items}) do
    %{
      data: render_many(items, __MODULE__, "person.json", as: :item)
    }
  end
end