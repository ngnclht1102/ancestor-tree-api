defmodule AppWeb.Admin.V1.PersonController do
  use AppWeb, :controller
  alias App.Person.Admin.PersonManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def index(conn, params) do
    %{current_family: current_family} = conn.assigns

    %{count: count, records: records} =
      PersonManager.list_person_of_given_family(current_family, params)

    %{page_size: page_size, page_number: _page_number, offset: offset} =
      App.Repo.paginate_params(params)

    conn
    |> put_resp_header("content-range", "items #{offset}-#{page_size}/#{count}")
    |> put_resp_header("Access-Control-Expose-Headers", "Content-Range")
    |> render("index.json", items: records)
  end

  def create(conn, params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, person} <- PersonManager.create_new_person(current_admin, params) do
      render(conn, "show.json", item: person)
    end
  end

  def update(conn, %{"id" => id} = params) do
    %{current_admin: current_admin} = conn.assigns

    with {:ok, person} <- PersonManager.update_person(current_admin, id, params) do
      render(conn, "show.json", item: person)
    end
  end

  def update(_, _), do: {:missing_params, [:id]}

  def delete(conn, %{"id" => id}) do
    with {:ok, person} <- PersonManager.remove_person(id) do
      render(conn, "show.json", item: person)
    end
  end

  def delete(_, _), do: {:missing_params, [:id]}

  def show(conn, %{"id" => id}) do
    case PersonManager.load_person(id) do
      nil ->
        {:error, :not_found}

      any ->
        render(conn, "show.json", item: any)
    end
  end

  def tree(conn, params) do
    %{current_family: current_family} = conn.assigns

    %{root: root, children: children} = PersonManager.load_tree_of_family(current_family)

    conn
    |> render("tree.json", root: root, children: children)
  end

  def tree_from(conn, %{"from_person_id" => from_person_id}) do
    %{current_family: current_family} = conn.assigns

    %{root: root, children: children} =
      PersonManager.load_tree_of_family(from_person_id, current_family)

    conn
    |> render("tree.json", root: root, children: children)
  end
end
