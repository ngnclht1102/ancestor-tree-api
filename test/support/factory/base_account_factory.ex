defmodule App.Factory.AccountFactory do
  @moduledoc """
  Ex Machina Factory for account-related schema
  """
  alias App.Base.Account.{AdminUser, Session, User}
  alias App.Base.Ext.Helper.AuthToken
  alias Faker.{Lorem, Name, Internet}

  defmacro __using__(_opts) do
    quote do
      def session_factory do
        %Session{
          email: Internet.email(),
          user: build(:user)
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
        %AdminUser{
          email: Internet.email(),
          password: Lorem.word(),
          user: build(:user)
        }
      end
    end
  end
end
