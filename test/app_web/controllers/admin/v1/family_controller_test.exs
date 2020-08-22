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

      created_res =
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
  end
end
