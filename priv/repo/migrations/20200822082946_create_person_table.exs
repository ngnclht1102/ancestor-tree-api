defmodule App.Repo.Migrations.CreatePersonTable do
  use Ecto.Migration

  def change do
    create(table(:persons)) do
      add(:family_id, references(:families))
      add(:father_id, references(:persons))
      add(:mother_id, references(:persons))
      add(:spouse_id, references(:persons))
      add(:created_by_id, references(:admin_users))

      add(:full_name, :string)
      add(:nickname, :string)
      add(:gender, :string)
      add(:family_level, :integer)
      add(:sibling_level, :integer)
      add(:note, :text)
      add(:dob_date, :integer)
      add(:dob_month, :integer)
      add(:dob_year, :integer)
      add(:dob_in_lunar, :boolean)
      add(:dod_date, :integer)
      add(:dod_month, :integer)
      add(:dod_year, :integer)
      add(:dod_in_lunar, :boolean)
      add(:is_alive, :boolean)
      add(:is_root, :boolean)
      add(:deleted_at, :naive_datetime)

      timestamps()
    end
  end
end
