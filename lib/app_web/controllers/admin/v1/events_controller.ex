defmodule AppWeb.Admin.V1.EventController do
  use AppWeb, :controller
  alias App.Event.Admin.EventManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def index(conn, params) do
    %{current_family: current_family} = conn.assigns

    %{count: count, records: records} =
      EventManager.list_events_of_given_family(current_family, params)

    %{page_size: page_size, page_number: _page_number, offset: offset} =
      App.Repo.paginate_params(params)

    conn
    |> put_resp_header("content-range", "items #{offset}-#{page_size}/#{count}")
    |> put_resp_header("Access-Control-Expose-Headers", "Content-Range")
    |> render("index.json", items: records)
  end

  def create(conn, params) do
    %{current_admin: current_admin, current_family: current_family} = conn.assigns

    with {:ok, event} <- EventManager.create_new_event(current_admin, current_family, params) do
      render(conn, "show.json", item: event)
    end
  end

  def update(conn, %{"id" => id} = params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, event} <- EventManager.update_person(current_admin, id, params) do
      render(conn, "show.json", item: event)
    end
  end

  def update(_, _), do: {:missing_params, [:id]}

  def delete(conn, %{"id" => id}) do
    with {:ok, event} <- EventManager.remove_person(id) do
      render(conn, "show.json", item: event)
    end
  end

  def delete(_, _), do: {:missing_params, [:id]}

  def show(conn, %{"id" => id}) do
    case EventManager.load_person(id) do
      nil -> {:error, :not_found}
      any ->
        render(conn, "show.json", item: any)
    end
  end
end
