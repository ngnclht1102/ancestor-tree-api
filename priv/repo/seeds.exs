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
alias App.Family.FamilyManager
import Ecto.Query, only: [from: 1]

count_admin = from(u in AdminUser) |> Repo.aggregate(:count, :id)

if count_admin == 0 do
  # create super admin
  %{
    first_name: "Nguyen",
    last_name: "Nam",
    email: "admin@ancestortree.com",
    password: "Ancestortree@2020"
  }
  |> AuthManager.create_admin_user()

  # create family owner
  {:ok, %{admin_user: admin_user, user: _user, session: _session}} =
    AuthManager.create_normal_user("ngnclht@gmail.com", "Ancestortree@2020")

  # create family
  FamilyManager.create_new_family(admin_user, %{
    "name" => "Nguyễn Sỹ - Can Lộc Hà Tĩnh",
    "main_address" => "Can Lộc Hà Tĩnh",
    "description" => ""
  })
end
