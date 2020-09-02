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
    if not is_nil(conn.params) and not is_nil(conn.params) do
      %{current_admin: current_admin} = conn.assigns
      family_id = Map.get(conn.params, "family_id")
      # this should be person id
      person_id = Map.get(conn.params, "id")

      if family_id do
        conn |> check_family(family_id, current_admin)
      else
        person = Person |> Repo.get(person_id)

        if not is_nil(person) do
          conn |> check_family(person.family_id, current_admin)
        else
          render_unauthorized(conn)
        end
      end
    else
      render_unauthorized(conn)
    end
  end

  def check_family(conn, family_id, current_admin) do
    family = Family |> Repo.get(family_id)

    if not is_nil(family) and family.owner_id == current_admin.id do
      conn |> assign(:current_family, family)
    else
      render_unauthorized(conn)
    end
  end

  def render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Unauthorized access, you are not authorized to access this family"})
    |> halt()
  end
end
