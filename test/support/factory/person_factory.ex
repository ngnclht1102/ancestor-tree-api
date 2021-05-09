defmodule App.Factory.PersonFactory do
  @moduledoc """
  Person Factory for Person schema
  """
  alias App.Person.Person
  alias Faker.{Lorem}
  alias Faker.Person, as: FPerson

  @spec __using__(any) ::
          {:def, [{:context, App.Factory.PersonFactory} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {:person_factory, [...], App.Factory.PersonFactory}, ...]}
  defmacro __using__(_opts) do
    quote do
      def person_factory do
        %Person{
          full_name: FPerson.name(),
          nickname: FPerson.name(),
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

      def non_root_person_factory do
        %Person{
          full_name: FPerson.name(),
          nickname: FPerson.name(),
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
          is_dead: false,
          is_root: false,
          gender: "male"
        }
      end
    end
  end
end
