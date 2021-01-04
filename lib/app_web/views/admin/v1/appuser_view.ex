defmodule AppWeb.Admin.V1.AppUserView do
  use AppWeb, :view

  def render("show.json", %{item: item}) do
    %{
      data: render_one(item, __MODULE__, "appuser.json", as: :item)
    }
  end

  def render("appuser.json", %{item: item}) do
    %{
      id: item.id,
      email: item.email,
      name: item.name,
      family_id: item.family_id,
    }
  end

  def render("index.json", %{items: items}) do
    %{
      data: render_many(items, __MODULE__, "appuser.json", as: :item)
    }
  end
end
