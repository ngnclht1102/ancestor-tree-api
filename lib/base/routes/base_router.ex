defmodule App.Base.Router do
  defmacro register_base_route(opts \\ []) do
    quote bind_quoted: binding() do
      pipeline :public_api do
        plug :accepts, ["json"]
      end

      pipeline :admin_api do
        plug :accepts, ["json"]
        plug App.Base.Plugs.AdminAuthPlug
      end

      scope "/public", App.Base.Controllers do
        pipe_through :public_api

        post("/login", AdminSessionController, :login)
      end

      scope "/admin", App.Base.Controllers do
        pipe_through :admin_api
        get("/sessions", AdminSessionController, :info)
      end
    end
  end
end
