defmodule App.Base.Controllers.User.AuthController do
  use AppWeb, :controller
  alias App.Base.Account.AuthManager

  action_fallback(App.Base.Ext.Controller.FallbackController)

  def register(_conn, params) do
    %{"email" => email, "password" => password} = params

    AuthManager.create_normal_user(email, password)
    |> case do
      {:ok, %{user: user, session: _session, admin_user: _admin_user}} ->
        {:ok,
         %{
           id: user.id,
           access_token: user.access_token,
           email: user.email
         }}

      error ->
        error
    end
  end
end
