defmodule App.Repo.Migrations.AddAppUseToSessionTable do
  use Ecto.Migration

  def change do
    alter(table(:sessions)) do
      add(:app_user_id, references(:app_users))
    end
  end
end
