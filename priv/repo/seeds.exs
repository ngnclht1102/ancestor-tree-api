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
      first_name: "Nguyễn Sĩ",
      last_name: "Giang Nam",
      email: "superadmin@honguyensi.com",
      password: "Ancestortree@2020"
    }
    |> AuthManager.create_admin_user()

  # create family owner
  {:ok, owner} =
    {:ok, %{admin_user: admin_user, user: _user, session: _session}} =
    AuthManager.create_normal_user("admin@honguyensi.com", "12345678")

  # create family
  {:ok, family} =
    FamilyManager.create_new_family(admin_user, %{
      "name" => "Nguyễn Sỹ - Đông Tây - Phú Lộc - Can Lộc Hà Tĩnh",
      "main_address" => "Phú Lộc - Can Lộc Hà Tĩnh",
      "description" => ""
    })

  {:ok, coLai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Lai",
      "nickname" => "",
      "note" => "",
      "dob_in_lunar" => true,
      "dod_in_lunar" => true,
      "is_alive" => false,
      "gender" => "male"
    })

  {:ok, coDoi} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Phạm Thị Đôi",
      "nickname" => "",
      "note" => "",
      "dob_in_lunar" => true,
      "dod_in_lunar" => true,
      "is_alive" => false,
      "gender" => "female",
      "spouse_id" => coLai.id
    })

  {:ok, ongMai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Thọ",
      "nickname" => "",
      "sibling_level" => 9,
      "note" => "",
      "dob_year" => 1940,
      "dob_in_lunar" => true,
      "dod_year" => 2020,
      "dod_in_lunar" => true,
      "is_alive" => false,
      "gender" => "male",
      "father_id" => coLai.id
    })

  {:ok, baMai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Phạm Thị Chín",
      "nickname" => "",
      "sibling_level" => 9,
      "note" => "",
      "dob_year" => 1944,
      "dob_in_lunar" => true,
      "dod_in_lunar" => true,
      "is_alive" => false,
      "gender" => "female",
      "spouse_id" => ongMai.id
    })

  {:ok, ongHung} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sĩ Tiến",
      "nickname" => "ông Hùng",
      "sibling_level" => 8,
      "note" => "",
      "dob_in_lunar" => true,
      "is_alive" => false,
      "gender" => "male",
      "father_id" => coLai.id
    })

  {:ok, baHung} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Trần Thị Soa",
      "nickname" => "",
      "note" => "",
      "dod_in_lunar" => false,
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => ongHung.id
    })

  {:ok, ongCung} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sĩ Tước",
      "nickname" => "ông Cung",
      "note" => "",
      "is_alive" => true,
      "gender" => "male",
      "father_id" => coLai.id
    })

  {:ok, baCung} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Bà Cung",
      "nickname" => "",
      "note" => "",
      "is_alive" => false,
      "gender" => "female",
      "spouse_id" => ongCung.id
    })

  {:ok, boTruc} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Trúc",
      "nickname" => "",
      "sibling_level" => 2,
      "note" => "",
      "dob_year" => 1968,
      "dob_in_lunar" => true,
      "is_alive" => true,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, meHai} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Trần Thị Hải",
      "nickname" => "",
      "note" => "",
      "dob_year" => 1969,
      "dob_in_lunar" => true,
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => boTruc.id
    })

  {:ok, chuHoang} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Hoàng",
      "nickname" => "",
      "sibling_level" => 3,
      "note" => "",
      "dob_year" => 1975,
      "dob_in_lunar" => true,
      "is_alive" => true,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, muHang} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Thị Hằng",
      "nickname" => "",
      "note" => "",
      "dob_year" => 1988,
      "dob_in_lunar" => true,
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => chuHoang.id
    })

  {:ok, chuHoan} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Hoan",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, muLinh} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Trần Thị Hồng Linh",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => chuHoan.id
    })

  {:ok, chuNham} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Nhâm",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, muNhan} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Thị Thanh Nhàn",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => chuNham.id
    })

  {:ok, chuHoanf} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Nguyễn Sỹ Hoàn",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "male",
      "mother_id" => baMai.id,
      "father_id" => ongMai.id
    })

  {:ok, muNhan} =
    family
    |> PersonManager.create_new_person(owner.user, %{
      "full_name" => "Trịnh Thị Lan",
      "nickname" => "",
      "note" => "",
      "is_alive" => true,
      "gender" => "female",
      "spouse_id" => chuHoanf.id
    })
end
