defmodule App.Repo.Migrations.CreateAdminUsersTable do
  use Ecto.Migration

  def change do
    create(table(:admin_users)) do
      add(:email, :text)
      add(:name, :string)
      add(:role, :string, default: "admin", null: false)
      add(:enabled, :boolean, default: true)
      add(:user_id, references(:users))
      add(:admin_user_id, references(:admin_users))
      add(:created_by_id, references(:admin_users))
      add(:password_hash, :text, null: false)
      add(:access_token, :text)
      add(:deleted_at, :naive_datetime)

      timestamps()
    end

    create(index(:admin_users, [:email], unique: true))
    create(index(:admin_users, [:access_token], unique: true))
  end
end
