defmodule AppWeb.Base.AuthControllerTest do
  use AppWeb.ConnCase

  describe "auth" do
    test "POST /user/public/register Register new account via email and password" do
      email = "test@example.com"
      password = "ThisIsN76Pas%$"

      res =
        build_conn()
        |> post("/user/public/register", %{email: email, password: password})
        |> doc(
          description: "Register as a normal user via email and password",
          operation_id: "register_via_email_and_password"
        )
        |> json_response(200)

      assert res["data"]

      duplicated_res =
        build_conn()
        |> post("/user/public/register", %{email: email, password: password})
        |> json_response(400)

      assert duplicated_res["errors"]
    end
  end
end
