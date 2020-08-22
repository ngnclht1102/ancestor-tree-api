defmodule App.Plugs.AdminOwnerPlug do
  @moduledoc """
  plug to check if the admin is owner of the given family via family_id in conn.params
  """
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias App.{Repo}
  alias App.Family.Family
  alias App.Person.Person

  def init([]), do: []

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opt) do
    if not is_nil(conn.params) and not is_nil(conn.params)do
      %{current_admin: current_admin} = conn.assigns
      family_id = Map.get(conn.params, "family_id")

      if family_id do
        family = Family |> Repo.get(family_id)
        if not is_nil(family) and family.owner_id == current_admin.id do
          conn |> assign(:current_family, family)
        else
          render_unauthorized(conn)
        end
      else
        render_unauthorized(conn)
      end
    else
      render_unauthorized(conn)
    end
  end

  @spec render_unauthorized(Plug.Conn.t()) :: Plug.Conn.t()
  def render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Unauthorized access, you are not authorized to access this family"})
    |> halt()
  end
end
