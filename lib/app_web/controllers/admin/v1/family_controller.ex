defmodule AppWeb.Admin.V1.FamilyController do
  use AppWeb, :controller
  alias App.Family.Admin.FamilyManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def index(conn, params) do
    %{current_admin: current_admin} = conn.assigns

    items = FamilyManager.list_families_of_an_owner(current_admin, params)

    render(conn, "index.json", items: items)
  end

  @spec create(atom | %{assigns: %{current_admin: atom | %{id: any}}}, map) :: any
  def create(conn, params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, family} <- FamilyManager.create_new_family(current_admin, params) do
      render(conn, "show.json", item: family)
    end
  end
end
