defmodule App.Repo.Migrations.AddFamilyIdToUserTable do
  use Ecto.Migration

  def change do
    create(table(:app_users)) do
      add(:email, :text)
      add(:user_id, references(:users))
      add(:family_id, references(:families))
      add(:person_id, references(:persons))
      add(:password_hash, :text, null: false)
      add(:access_token, :text)
      add(:deleted_at, :naive_datetime)
      add(:role, :string, default: "app-user", null: false)
      add(:name, :string)
      add(:enabled, :boolean, default: true)

      timestamps()
    end

    create(index(:app_users, [:email], unique: true))
    create(index(:app_users, [:access_token], unique: true))
  end
end
