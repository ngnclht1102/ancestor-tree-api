defmodule App.Repo.Migrations.AddNotForListingToUserTable do
  use Ecto.Migration

  def change do
    alter(table(:persons)) do
      add(:belong_to_main_list_of_family, :boolean, default: true)
    end
  end
end
