defmodule App.Base.Account.AdminAppUserManager do
  @moduledoc """
  app user manager for ADMIN only
  """

  alias App.Base.Ext.Helper.AuthToken
  alias App.Repo
  alias App.Base.Account.{AdminUser, User, Session, AdminUserManager, AppUser}
  alias App.Base.Account.AuthManager

  alias Ecto.Multi

  import Ecto.Query, only: [from: 2]

  def verify_admin_user(%AdminUser{} = user, password) do
    user
    |> Argon2.check_pass(password)
  end

  def get_app_user(id), do: Repo.get(AppUser, id)

  def get_app_by_email(email), do: Repo.get_by(AppUser, email: email)

  def create_app_user(email, password, family_id, name) do
    {:ok, access_token, _} = AuthManager.generate_access_token(email)

    user_changeset =
      User.create_changeset(
        %User{},
        %{
          full_name: name,
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
        name: name,
        family_id: family_id,
        email: email,
        role: AppUser.appuser_role(),
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

  def list_appusers_of_given_family(current_family, params) do
    query = from(
      au in AppUser,
      where: au.family_id == ^current_family.id,
      where: is_nil(au.deleted_at)
    )

    records = query |> Repo.paginate(params)
    count = query |> Repo.aggregate(:count, :id)
    %{count: count, records: records}
  end

  def load_appuser(id) do
    AppUser |> Repo.get(id)
  end

  def update_appuser(id, params) do
    appuser = AppUser |> Repo.get(id)
    if appuser do
      changeset = AppUser.admin_update_changeset(appuser, params)
      changeset |> Repo.update
    else
      {:notfound}
    end
  end

  def delete_appuser(id) do
    appuser = AppUser |> Repo.get(id)
    if appuser do
      changeset = AppUser.admin_delete_changeset(appuser)
      changeset |> Repo.update
    else
      {:notfound}
    end
  end
end
