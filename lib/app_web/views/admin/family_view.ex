defmodule AppWeb.Admin.FamilyView do
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
      description: item.description
    }
  end
end
