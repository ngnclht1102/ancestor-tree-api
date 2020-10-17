defmodule AppWeb.Admin.V1.FamilyControllerTest do
  use AppWeb.ConnCase

  alias App.Base.Account.AuthManager

  setup do
    params = params_for(:admin_user)

    {:ok, %{admin_user: admin_user, user: _user, session: _session}} =
      AuthManager.create_normal_user(
        params.email,
        params.password
      )

    {:ok, %{admin_user: admin_user}}
  end

  describe "family" do
    test "POST /admin/v1/families create family",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/families", family_params)
        |> doc(
          description: "Create family",
          operation_id: "create_family"
        )
        |> json_response(200)

      assert res["data"]
    end

    test "GET /admin/v1/families list families of current owner",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-access-token", admin_user.access_token)
      |> post("/admin/v1/families", family_params)
      |> json_response(200)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/families")
        |> doc(
          description: "List family of current owner",
          operation_id: "list_family"
        )
        |> json_response(200)

      assert res["data"]
    end

    test "PUT /admin/v1/families/:id update family",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/families", family_params)
        |> json_response(200)

      id = created_res["data"]["id"]

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> put(
          "/admin/v1/families/#{id}",
          Map.merge(family_params, %{
            "name" => "Edited name"
          })
        )
        |> doc(
          description: "Update family",
          operation_id: "update_family"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["name"] == "Edited name"
    end

    test "DELETE /admin/v1/families/:id delete family",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/families", family_params)
        |> json_response(200)

      id = created_res["data"]["id"]

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> delete("/admin/v1/families/#{id}")
        |> doc(
          description: "delete family",
          operation_id: "delete_family"
        )
        |> json_response(200)

      assert res["data"]
      assert res["data"]["deleted_at"]

      list_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/families")
        |> json_response(200)

      assert list_res["data"] == []
    end

    test "DELETE /admin/v1/families/:id get family",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      created_res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/v1/families", family_params)
        |> json_response(200)

      id = created_res["data"]["id"]

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> get("/admin/v1/families/#{id}")
        |> doc(
          description: "show family",
          operation_id: "show_family"
        )
        |> json_response(200)

      assert res["data"]
    end
  end
end
