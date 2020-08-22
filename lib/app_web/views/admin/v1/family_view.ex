defmodule AppWeb.Admin.V1.FamilyView do
  use AppWeb, :view

  def render("show.json", %{item: item}) do
    %{
      data: render_one(item, __MODULE__, "family.json", as: :item)
    }
  end

  def render("family.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      main_address: item.main_address,
      description: item.description,
      owner_id: item.owner_id,
      deleted_at: item.deleted_at
    }
  end

  def render("index.json", %{items: items}) do
    %{
      data: render_many(items, __MODULE__, "family.json", as: :item)
    }
  end
end
