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
alias App.Family.Admin.FamilyManager
alias App.Person.Admin.PersonManager
import Ecto.Query, only: [from: 1]

count_admin = from(u in AdminUser) |> Repo.aggregate(:count, :id)

if count_admin == 0 do
  # create super admin
  {:ok, admin_user} =
    %{
      first_name: "Nguyen",
      last_name: "Nam",
      email: "admin@ancestortree.com",
      password: "Ancestortree@2020"
    }
    |> AuthManager.create_admin_user()

  # create family owner
  {:ok, owner} =
    {:ok, %{admin_user: admin_user, user: _user, session: _session}} =
    AuthManager.create_normal_user("ngnclht@gmail.com", "Ancestortree@2020")

  # create family
  {:ok, family} =
    FamilyManager.create_new_family(admin_user, %{
      "name" => "Nguyễn Sỹ - Can Lộc Hà Tĩnh",
      "main_address" => "Can Lộc Hà Tĩnh",
      "description" => ""
    })

  {:ok, coLai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Lai",
      "nickname" => "",
      "family_level" => 1,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1900,
      "dob_in_lunar" => true,
      "dod_date" => 2,
      "dod_month" => 4,
      "dod_year" => 1950,
      "dod_in_lunar" => true,
      "is_alive" => true,
      "is_root" => true,
      "gender" => "male"
    })

  {:ok, ongMai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Thọ",
      "nickname" => "",
      "family_level" => 2,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1940,
      "dob_in_lunar" => true,
      "dod_date" => 2,
      "dod_month" => 4,
      "dod_year" => 2020,
      "dod_in_lunar" => true,
      "is_alive" => true,
      "is_root" => false,
      "gender" => "male",
      "parent_id" => coLai.id
    })

  {:ok, baMai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Phạm Thị Chín",
      "nickname" => "",
      "family_level" => 2,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1940,
      "dob_in_lunar" => true,
      "dod_in_lunar" => true,
      "is_alive" => false,
      "is_root" => false,
      "gender" => "female",
      "spouse_id" => ongMai.id
    })

  {:ok, boTruc} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Trúc",
      "nickname" => "",
      "family_level" => 3,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1968,
      "dob_in_lunar" => true,
      "is_alive" => false,
      "is_root" => false,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, meHai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Trần Thị Hải",
      "nickname" => "",
      "family_level" => 3,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1969,
      "dob_in_lunar" => true,
      "is_alive" => false,
      "is_root" => false,
      "gender" => "female",
      "spouse_id" => boTruc.id
    })

  {:ok, chuHoang} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Hoàng",
      "nickname" => "",
      "family_level" => 3,
      "sibling_level" => 3,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1975,
      "dob_in_lunar" => true,
      "is_alive" => false,
      "is_root" => false,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, muHang} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Thị Hằng",
      "nickname" => "",
      "family_level" => 3,
      "sibling_level" => 2,
      "note" => "",
      "dob_date" => 11,
      "dob_month" => 11,
      "dob_year" => 1988,
      "dob_in_lunar" => true,
      "is_alive" => false,
      "is_root" => false,
      "gender" => "female",
      "spouse_id" => chuHoang.id
    })
end
