defmodule AppWeb.Admin.V1.FamilyController do
  use AppWeb, :controller
  alias App.Family.Admin.FamilyManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  @spec index(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def index(conn, params) do
    %{current_admin: current_admin} = conn.assigns
    %{ count: count, records: records}  = FamilyManager.list_families_of_an_owner(current_admin, params)

    %{ page_size: page_size, page_number: _page_number, offset: offset } = App.Repo.paginate_params(params)
    conn
    |> put_resp_header("content-range", "items #{offset}-#{page_size}/#{count}")
    |> put_resp_header("Access-Control-Expose-Headers", "Content-Range")
    |> render( "index.json", items: records)
  end

  def create(conn, params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, family} <- FamilyManager.create_new_family(current_admin, params) do
      render(conn, "show.json", item: family)
    end
  end

  def show(conn, %{"id" => id}) do
    %{current_admin: current_admin} = conn.assigns

    family = FamilyManager.load_family(current_admin, id)
    case family do
      nil -> {:error, :not_found}
      _ ->
      render(conn, "show.json", item: family)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, family} <- FamilyManager.update_family(id, params) do
      render(conn, "show.json", item: family)
    end
  end

  def update(_, _), do: {:missing_params, [:id]}

  def delete(conn, %{"id" => id}) do
    with {:ok, family} <- FamilyManager.remove_family(id) do
      render(conn, "show.json", item: family)
    end
  end

  def delete(_, _), do: {:missing_params, [:id]}
end
