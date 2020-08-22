defmodule App.Factory.AccountFactory do
  @moduledoc """
  Ex Machina Factory for account-related schema
  """
  alias App.Base.Account.{AdminUser, Session, User}
  alias App.Base.Ext.Helper.AuthToken
  import Argon2, only: [add_hash: 1]
  alias Faker.{Lorem, Name, Internet}

  defmacro __using__(_opts) do
    quote do
      def session_factory do
        %Session{
          email: Internet.email()
        }
      end

      def user_factory do
        email = Internet.email()
        {:ok, access_token, _} = AuthToken.generate_and_sign(%{"email" => email})

        %User{
          access_token: access_token,
          email: email,
          first_name: Name.first_name(),
          last_name: Name.last_name()
        }
      end

      def admin_user_factory do
        email = Internet.email()
        user = build(:user)
        {:ok, access_token, _} = AuthToken.generate_and_sign(%{"email" => email})

        %AdminUser{
          email: email,
          access_token: access_token,
          password: Lorem.word(),
          user: user
        }
      end
    end
  end
end
