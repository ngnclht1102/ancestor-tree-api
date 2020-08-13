defmodule App.Base.Plugs.AdminAuthPlug do
  @moduledoc """
  Authentication plug for admin
  """
  import Plug.Conn
  alias App.{Repo}
  alias App.Base.Account.AdminUser
  import App.Base.Ext.Helper.AuthToken, only: [verify_token: 1]
  import Phoenix.Controller, only: [json: 2]
  import Ecto.Query, only: [from: 2]

  def init([]), do: []

  def call(conn, _opts) do
    case get_req_header(conn, "x-access-token") do
      [access_token | _] when not is_nil(access_token) ->
        with {:ok, %{"email" => email}} <- verify_token(access_token) do
          email = String.downcase(email)

          admin_user =
            from(
              u in AdminUser,
              where: [
                email: ^email
              ],
              where: u.enabled == true,
              where: is_nil(u.deleted_at),
              limit: 1
            )
            |> Repo.one()

          if admin_user do
            conn |> assign(:current_admin, admin_user)
          else
            render_unauthorized(conn)
          end
        else
          _ -> render_unauthorized(conn)
        end

      _ ->
        render_unauthorized(conn)
    end
  end

  def render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Unauthorized access"})
    |> halt()
  end
end
