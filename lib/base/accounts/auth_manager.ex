defmodule App.Base.Account.AuthManager do
  @moduledoc """
  user manager
  """

  alias App.Base.Ext.Helper.AuthToken
  alias App.Repo
  alias App.Base.Account.{AdminUser, User, Session, AdminUserManager}

  alias Ecto.Multi

  defp generate_access_token(email) do
    AuthToken.generate_and_sign(%{"email" => email})
  end

  @spec create_admin_user(%{email: any, password: any}) :: any
  def create_admin_user(params) do
    %{email: email, password: password} = params
    {:ok, access_token, _} = generate_access_token(email)

    user_changeset =
      User.create_changeset(
        %User{},
        Map.merge(params, %{
          access_token: access_token
        })
      )

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.insert(:admin_user, fn %{user: user} ->
      AdminUser.changeset(%AdminUser{}, %{
        user_id: user.id,
        access_token: access_token,
        email: email,
        name: "#{user.first_name} #{user.last_name}",
        password: password
      })
    end)
    |> Multi.insert(
      :session,
      fn %{admin_user: admin_user} ->
        Session.changeset(%Session{}, %{
          email: email,
          admin_user_id: admin_user.id
        })
      end
    )
    |> Repo.transaction()
  end

  def create_normal_user(email, password) when is_nil(email) or is_nil(password),
    do: {:error, %{message: "Empty params"}}

  def create_normal_user(email, password) do
    {:ok, access_token, _} = generate_access_token(email)

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
    |> Multi.insert(:session, fn %{user: user} ->
      Session.changeset(%Session{}, %{
        email: email,
        user_id: user.id
      })
    end)
    |> Repo.transaction()
  end

  def admin_login(email, password) when is_nil(email) and is_nil(password),
    do: {:error, :no_email_and_password}

  def admin_login(email, password) do
    user = AdminUserManager.get_admin_user_by_email(email)

    if user do
      user |> AdminUserManager.verify_admin_user(password)
    else
      {:error, %{:message => "No match user"}}
    end
  end
end
