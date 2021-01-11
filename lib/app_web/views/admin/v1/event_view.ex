defmodule AppWeb.Admin.V1.EventView do
  use AppWeb, :view

  def render("show.json", %{item: item}) do
    %{
      data: render_one(item, __MODULE__, "event.json", as: :item)
    }
  end

  def render("event.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      description: item.description,
      dt_in_lunar: item.dt_in_lunar,
      dt_date: item.dt_date,
      dt_month: item.dt_month,
      dt_year: item.dt_year,
      repeat: item.repeat,
      repeat_times: item.repeat_times,
      repeat_type: item.repeat_type,
      family_id: item.family_id
    }
  end

  def render("index.json", %{items: items}) do
    %{
      data: render_many(items, __MODULE__, "event.json", as: :item)
    }
  end
end
