defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_owner_api do
    plug :api
    plug :admin_api
    plug App.Plugs.AdminOwnerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  import App.Base.Router

  scope "/" do
    register_base_route()
  end

  scope "/", AppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/admin", AppWeb.Admin, as: :admin do
    pipe_through :admin_api

    scope "/v1/", V1 do
      resources("/families", FamilyController)
    end
  end

  scope "/admin", AppWeb.Admin, as: :admin do
    pipe_through :admin_owner_api

    scope "/v1/", V1 do
      resources("/persons", PersonController)
    end
  end
end
