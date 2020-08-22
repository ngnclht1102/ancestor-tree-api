defmodule App.Repo.Migrations.CreateFamiliesTable do
  use Ecto.Migration

  def change do
    create(table(:families)) do
      add(:name, :string)
      add(:main_address, :string)
      add(:description, :text)
      add(:deleted_at, :naive_datetime)

      add(:owner_id, references(:admin_users))
      timestamps()
    end
  end
end
