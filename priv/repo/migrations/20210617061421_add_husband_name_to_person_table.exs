defmodule App.Repo.Migrations.AddHusbandNameToPersonTable do
  use Ecto.Migration

  def change do
    alter(table(:persons)) do
      add(:husband_name, :string)
    end
  end
end
