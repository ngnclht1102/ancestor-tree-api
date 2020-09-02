defmodule App.Factory.PersonFactory do
  @moduledoc """
  Person Factory for Person schema
  """
  alias App.Person.Person
  alias Faker.{Lorem, Name}

  @spec __using__(any) ::
          {:def, [{:context, App.Factory.PersonFactory} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {:person_factory, [...], App.Factory.PersonFactory}, ...]}
  defmacro __using__(_opts) do
    quote do
      def person_factory do
        %Person{
          full_name: Name.name(),
          nickname: Name.name(),
          family_level: 3,
          sibling_level: 2,
          note: Lorem.Shakespeare.as_you_like_it(),
          dob_date: 11,
          dob_month: 11,
          dob_year: 1988,
          dob_in_lunar: true,
          dod_date: 5,
          dod_month: 1,
          dod_year: 1990,
          dod_in_lunar: true,
          is_dead: true,
          is_root: true,
          gender: "male"
        }
      end
    end
  end
end
