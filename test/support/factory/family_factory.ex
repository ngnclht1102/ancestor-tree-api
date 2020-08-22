defmodule App.Factory.FamilyFactory do
  @moduledoc """
  Family Factory for family schema
  """
  alias App.Family.Family
  alias Faker.{Lorem, Name, Address}

  @spec __using__(any) ::
          {:def, [{:context, App.Factory.FamilyFactory} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {:family_factory, [...], App.Factory.FamilyFactory}, ...]}
  defmacro __using__(_opts) do
    quote do
      def family_factory do
        %Family{
          name: Name.name(),
          main_address: "#{Address.city()} #{Address.country()}",
          description: Lorem.Shakespeare.as_you_like_it()
        }
      end
    end
  end
end
