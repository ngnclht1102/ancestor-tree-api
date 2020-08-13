defmodule App.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create(table(:users)) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :text, nullable: false)
      add(:phone_country_code, :string)
      add(:phone_number_without_code, :string)
      add(:nickname, :string)
      add(:dob_month, :integer)
      add(:dob_year, :integer)
      add(:access_token, :text)
      add(:state, :string)
      add(:gender, :string)
      add(:type, :string)
      add(:deleted_at, :naive_datetime)

      timestamps()
    end

    create(index(:users, [:email], unique: true))
    create(index(:users, [:access_token], unique: true))
    create(index(:users, [:phone_country_code, :phone_number_without_code], unique: true))
  end
end
