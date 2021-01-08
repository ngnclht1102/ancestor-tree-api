defmodule AppWeb.Admin.V1.AppUserController do
  use AppWeb, :controller
  alias App.Base.Account.AdminAppUserManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def index(conn, params) do
    %{current_family: current_family} = conn.assigns

    %{count: count, records: records} =
      AdminAppUserManager.list_appusers_of_given_family(current_family, params)

    %{page_size: page_size, page_number: _page_number, offset: offset} =
      App.Repo.paginate_params(params)

    conn
    |> put_resp_header("content-range", "items #{offset}-#{page_size}/#{count}")
    |> put_resp_header("Access-Control-Expose-Headers", "Content-Range")
    |> render("index.json", items: records)
  end

  def create(conn, %{ "email" => email, "password" => password, "family_id" => family_id, "name" => name}) do
    with {
      :ok,
      %{ app_user: app_user, session: _session, user: _user
    }} <- AdminAppUserManager.create_app_user(email, password, family_id, name) do
      render(conn, "show.json", item: app_user)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, appuser} <- AdminAppUserManager.update_appuser(id, params) do
      render(conn, "show.json", item: appuser)
    end
  end

  def update(_, _), do: {:missing_params, [:id]}

  def delete(conn, %{"id" => id}) do
    with {:ok, appuser} <- AdminAppUserManager.delete_appuser(id) do
      render(conn, "show.json", item: appuser)
    end
  end

  def delete(_, _), do: {:missing_params, [:id]}

  def show(conn, %{"id" => id}) do
    case AdminAppUserManager.load_appuser(id) do
      nil -> {:error, :not_found}
      any ->
        render(conn, "show.json", item: any)
    end
  end
end
