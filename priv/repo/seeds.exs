# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias App.Repo
alias App.Base.Account.AdminUser
alias App.Base.Account.AuthManager
import Ecto.Query, only: [from: 1]

count_admin = from(u in AdminUser) |> Repo.aggregate(:count, :id)

if count_admin == 0 do
  created_admin =
    %{
      first_name: "Nguyen",
      last_name: "Nam",
      email: "admin@ancestortree.com",
      password: "Ancestortree@2020"
    }
    |> AuthManager.create_admin_user()
end
