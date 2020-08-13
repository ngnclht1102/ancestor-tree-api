defmodule App.Base.Account.AdminUserManager do
  @moduledoc """
  admin user manager
  """
  alias App.Repo
  alias App.Base.Account.AdminUser

  def verify_admin_user(%AdminUser{} = user, password) do
    user
    |> Argon2.check_pass(password)
  end

  def get_admin_user(id), do: Repo.get(AdminUser, id)

  def get_admin_user_by_email(email), do: Repo.get_by(AdminUser, email: email)
end
