defmodule App.Base.Controllers.Admin.AdminSessionController do
  use AppWeb, :controller
  alias App.Base.Account.AuthManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def login(_conn, params) do
    %{"email" => email, "password" => password} = params

    AuthManager.admin_login(email, password)
    |> case do
      {:ok, user} ->
        {:ok,
         %{
           id: user.id,
           access_token: user.access_token,
           email: user.email,
           name: user.name
         }}

      error ->
        error
    end
  end

  def info(conn, _) do
    %{current_admin: current_admin} = conn.assigns

    {:ok,
     %{
       id: current_admin.id,
       access_token: current_admin.access_token,
       email: current_admin.email
     }}
  end
end
