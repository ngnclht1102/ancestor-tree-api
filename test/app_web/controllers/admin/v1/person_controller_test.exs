defmodule AppWeb.Admin.V1.PersonControllerTest do
  use AppWeb.ConnCase

  alias App.Base.Account.AuthManager

  setup do
    params = params_for(:admin_user)

    {:ok, %{admin_user: admin_user, user: _user, session: _session}} =
      AuthManager.create_normal_user(
        params.email,
        params.password
      )

    family = insert(:family, owner_id: admin_user.id)

    {:ok, %{admin_user: admin_user, family: family}}
  end

  describe "person" do
    test "POST /admin/v1/persons create person",
         %{admin_user: admin_user, family: family} do
      params =
        Map.merge(params_for(:person), %{
          family_id: family.id
        })

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> doc(
          description: "Create person",
          operation_id: "create_person"
        )
        |> json_response(200)

      assert res["data"]
    end

    test "GET /admin/v1/persons list person of given family",
         %{admin_user: admin_user, family: family} do
      params =
        Map.merge(params_for(:person), %{
          family_id: family.id
        })

      _created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/persons?family_id=#{family.id}")
        |> doc(
          description: "List person of given family id",
          operation_id: "list_person"
        )
        |> json_response(200)

      assert res["data"]
      [fisrt | _] = res["data"]
      assert fisrt["id"]
    end

    test "GET /admin/v1/persons/tree list as tree of given family",
         %{admin_user: admin_user, family: family} do
      params =
        Map.merge(params_for(:person), %{
          family_id: family.id
        })

      root_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      first_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      second_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      third_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"],
          spouse_id: third_child["data"]["id"]
        })

      third_child_wife =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/persons/tree?family_id=#{family.id}")
        |> doc(
          description: "List as tree of given family id",
          operation_id: "list_person_as_tree"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["id"] == root_res["data"]["id"]
      assert res["data"]["name"] == root_res["data"]["full_name"]
    end

    test "GET /admin/v1/persons/tree/:from_person_id list as tree of given family from specific person",
         %{admin_user: admin_user, family: family} do
      params =
        Map.merge(params_for(:person), %{
          family_id: family.id
        })

      root_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      first_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      second_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"]
        })

      third_child =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      params =
        Map.merge(params_for(:non_root_person), %{
          family_id: family.id,
          father_id: root_res["data"]["id"],
          spouse_id: third_child["data"]["id"]
        })

      third_child_wife =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/persons", params)
        |> json_response(200)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/persons/tree/#{root_res["data"]["id"]}/?family_id=#{family.id}")
        |> doc(
          description: "List as tree of given family id",
          operation_id: "list_person_as_tree"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["id"] == root_res["data"]["id"]
      assert res["data"]["name"] == root_res["data"]["full_name"]
    end

    test "PUT /admin/v1/persons/:id update person",
         %{admin_user: admin_user, family: family} do
      person_params = params_for(:person)

      created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post(
          "/admin/v1/persons",
          Map.merge(person_params, %{
            "family_id" => family.id
          })
        )
        |> json_response(200)

      id = created_res["data"]["id"]

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> put(
          "/admin/v1/persons/#{id}",
          Map.merge(person_params, %{
            "full_name" => "Edited name",
            "family_id" => family.id
          })
        )
        |> doc(
          description: "Update person",
          operation_id: "update_person"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["full_name"] == "Edited name"
    end

    test "DELETE /admin/v1/persons/:id delete person",
         %{admin_user: admin_user, family: family} do
      person_params = params_for(:person)

      created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post(
          "/admin/v1/persons",
          Map.merge(person_params, %{
            "family_id" => family.id
          })
        )
        |> json_response(200)

      id = created_res["data"]["id"]

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> delete(
          "/admin/v1/persons/#{id}",
          Map.merge(person_params, %{
            "family_id" => family.id
          })
        )
        |> doc(
          description: "delete person",
          operation_id: "delete_person"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["deleted_at"]
    end
  end
end
