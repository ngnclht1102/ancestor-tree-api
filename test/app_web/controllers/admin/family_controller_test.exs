defmodule AppWeb.Base.AuthControllerTest do
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

  describe "auth" do
    test "POST /admin/families create family",
         %{admin_user: admin_user} do
      family_params = params_for(:family)

      res =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-access-token", admin_user.access_token)
        |> post("/admin/families", family_params)
        |> doc(
          description: "Create family",
          operation_id: "create_family"
        )
        |> json_response(200)

      # assert res["data"]
      IO.puts("======================")
      IO.inspect(res)
      IO.puts("======================")
      assert res

      # duplicated_res =
      #   build_conn()
      #   |> post("/user/public/register", %{email: email, password: password})
      #   |> json_response(400)

      # assert duplicated_res["errors"]
    end
  end
end
