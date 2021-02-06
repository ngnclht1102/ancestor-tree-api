defmodule App.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create(table(:events)) do
      add(:created_by_id, references(:admin_users))
      add(:family_id, references(:families))
      add(:name, :string)
      add(:description, :text)
      add(:dt_in_lunar, :boolean)
      add(:dt_date, :integer)
      add(:dt_month, :integer)
      add(:dt_year, :integer)
      add(:time, :time)
      add(:deleted_at, :naive_datetime)
      add(:repeat_times, :integer, default: 1)
      add(:repeat_type, :string, default: "no-repeat")

      timestamps()
    end
  end
end
