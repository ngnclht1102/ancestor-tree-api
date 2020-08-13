defmodule App.Repo.Migrations.CreateAdminSessionsTable do
  use Ecto.Migration

  def change do
    create(table(:sessions)) do
      add(:email, :text)
      add(:phone_number, :string)
      add(:firebase_id, :text)
      add(:user_id, references(:users))
      add(:admin_user_id, references(:admin_users))
      add(:deleted_at, :naive_datetime)

      timestamps()
    end

    create(index(:sessions, [:email], unique: true))
    create(index(:sessions, [:phone_number], unique: true))
  end
end
