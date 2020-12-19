defmodule App.Plugs.AdminOwnerPlug do
  @moduledoc """
  plug to check if the admin is owner of the given family via family_id in conn.params
  """
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  import Ecto.Query, only: [from: 2]

  alias App.{Repo}
  alias App.Family.Family
  alias App.Person.Person

  def init([]), do: []

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opt) do
    if not is_nil(conn.params) and not is_nil(conn.params) do
      %{current_admin: current_admin} = conn.assigns
      family = case Map.get(conn.params, "family_id") do
        nil ->
          case from(p in Family, where: p.owner_id == ^current_admin.id, limit: 1) |> Repo.one() do
            nil -> nil
            family -> family
          end
        family_id -> Family |> Repo.get(family_id)
      end

      if family do
        conn |> check_family(family, current_admin)
      else
        render_unauthorized(conn)
      end
    else
      render_unauthorized(conn)
    end
  end

  def check_family(conn, family, current_admin) do
    if not is_nil(family) and family.owner_id == current_admin.id do
      conn |> assign(:current_family, family)
    else
      render_unauthorized(conn)
    end
  end

  def render_unauthorized(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{message: "Unauthorized access, you are not authorized to access this family"})
    |> halt()
  end
end
