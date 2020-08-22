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

  describe "family" do
    test "POST /admin/v1/persons create family",
         %{admin_user: admin_user, family: family} do
      params = Map.merge(params_for(:person), %{
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

  #   test "GET /admin/v1/persons list families of current owner",
  #        %{admin_user: admin_user, family: family} do
  #     family_params = params_for(:family)

  #     build_conn()
  #     |> put_req_header("accept", "application/json")
  #     |> put_req_header("x-access-token", admin_user.access_token)
  #     |> post("/admin/v1/persons", family_params)
  #     |> json_response(200)

  #     res =
  #       build_conn()
  #       |> put_req_header("accept", "application/json")
  #       |> put_req_header("x-access-token", admin_user.access_token)
  #       |> get("/admin/v1/persons")
  #       |> doc(
  #         description: "List family of current owner",
  #         operation_id: "list_family"
  #       )
  #       |> json_response(200)

  #     assert res["data"]
  #   end

  #   test "PUT /admin/v1/persons/:id update family",
  #        %{admin_user: admin_user, family: family} do
  #     family_params = params_for(:family)

  #     created_res =
  #       build_conn()
  #       |> put_req_header("accept", "application/json")
  #       |> put_req_header("x-access-token", admin_user.access_token)
  #       |> post("/admin/v1/persons", family_params)
  #       |> json_response(200)

  #     id = created_res["data"]["id"]

  #     res =
  #       build_conn()
  #       |> put_req_header("accept", "application/json")
  #       |> put_req_header("x-access-token", admin_user.access_token)
  #       |> put(
  #         "/admin/v1/persons/#{id}",
  #         Map.merge(family_params, %{
  #           "name" => "Edited name"
  #         })
  #       )
  #       |> doc(
  #         description: "Update family",
  #         operation_id: "update_family"
  #       )
  #       |> json_response(200)

  #     assert res["data"]
  #     assert res["data"]["name"] == "Edited name"
  #   end
  # end

  # test "DELETE /admin/v1/persons/:id delete family",
  #      %{admin_user: admin_user, family: family} do
  #   family_params = params_for(:family)

  #   created_res =
  #     build_conn()
  #     |> put_req_header("accept", "application/json")
  #     |> put_req_header("x-access-token", admin_user.access_token)
  #     |> post("/admin/v1/persons", family_params)
  #     |> json_response(200)

  #   id = created_res["data"]["id"]

  #   res =
  #     build_conn()
  #     |> put_req_header("accept", "application/json")
  #     |> put_req_header("x-access-token", admin_user.access_token)
  #     |> delete("/admin/v1/persons/#{id}")
  #     |> doc(
  #       description: "delete family",
  #       operation_id: "delete_family"
  #     )
  #     |> json_response(200)

  #   assert res["data"]
  #   assert res["data"]["deleted_at"]

  #   list_res =
  #     build_conn()
  #     |> put_req_header("accept", "application/json")
  #     |> put_req_header("x-access-token", admin_user.access_token)
  #     |> get("/admin/v1/persons")
  #     |> json_response(200)

  #   assert list_res["data"] == []
  end
end
