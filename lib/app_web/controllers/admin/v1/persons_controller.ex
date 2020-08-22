defmodule AppWeb.Admin.V1.PersonController do
  use AppWeb, :controller
  alias App.Person.Admin.PersonManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  # def index(conn, params) do
  #   %{current_admin: current_admin} = conn.assigns

  #   items = FamilyManager.list_families_of_an_owner(current_admin, params)

  #   render(conn, "index.json", items: items)
  # end

  def create(conn, params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, person} <- PersonManager.create_new_person(current_admin, params) do
      render(conn, "show.json", item: person)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, person} <- PersonManager.update_person(id, params) do
      render(conn, "show.json", item: person)
    end
  end

  def update(_, _), do: {:missing_params, [:id]}

  # def delete(conn, %{"id" => id}) do
  #   with {:ok, family} <- FamilyManager.remove_family(id) do
  #     render(conn, "show.json", item: family)
  #   end
  # end

  # def delete(_, _), do: {:missing_params, [:id]}
end
