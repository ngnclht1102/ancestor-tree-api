defmodule App.Base.Account.AppUserManager do
  @moduledoc """
  user manager
  """

  alias App.Base.Ext.Helper.AuthToken
  alias App.Repo
  alias App.Base.Account.{AdminUser, User, Session, AdminUserManager, AppUser}
  alias App.Base.Account.AuthManager

  alias Ecto.Multi


  def verify_admin_user(%AdminUser{} = user, password) do
    user
    |> Argon2.check_pass(password)
  end

  def get_app_user(id), do: Repo.get(AppUser, id)

  def get_app_by_email(email), do: Repo.get_by(AppUser, email: email)

  def create_app_user(email, password) do
    {:ok, access_token, _} = AuthManager.generate_access_token(email)

    user_changeset =
      User.create_changeset(
        %User{},
        %{
          email: email,
          password: password,
          access_token: access_token
        }
      )

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.insert(:app_user, fn %{user: user} ->
      AppUser.changeset(%AppUser{}, %{
        user_id: user.id,
        access_token: access_token,
        email: email,
        role: AppUser.appuser_role(),
        name: "#{user.first_name} #{user.last_name}",
        password: password
      })
    end)
    |> Multi.insert(:session, fn %{user: user, app_user: app_user} ->
      Session.changeset(%Session{}, %{
        email: email,
        user_id: user.id,
        app_user_id: app_user.id
      })
    end)
    |> Repo.transaction()
  end
end
