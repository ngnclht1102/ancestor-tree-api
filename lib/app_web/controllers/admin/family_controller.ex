defmodule AppWeb.Controllers.Admin.FamilyController do
  use AppWeb, :controller
  alias App.Base.Account.AuthManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def index(conn, params) do
  end

  def create(conn, params) do
    IO.puts("======================")
    IO.puts("======================")
    %{current_admin: current_admin} = conn.assign
    {:ok}
  end
end
