defmodule LifeComplexWeb.Router do
  use LifeComplexWeb, :router

  import LifeComplexWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LifeComplexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LifeComplexWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LifeComplexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  # if Application.compile_env(:life_complex, :dev_routes) do
  #   # If you want to use the LiveDashboard in production, you should put
  #   # it behind authentication and allow only admins to access it.
  #   # If your application does not have an admins-only section yet,
  #   # you can use Plug.BasicAuth to set up some basic authentication
  #   # as long as you are also using SSL (which you should anyway).
  #   import Phoenix.LiveDashboard.Router
  #
  #   scope "/dev" do
  #     pipe_through :browser
  #
  #     live_dashboard "/dashboard", metrics: LifeComplexWeb.Telemetry
  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
  
  pipeline :admins_only do
    plug :admin_basic_auth
  end

  scope "/admin" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", ecto_repos: [LifeComplex.Repo], metrics: LifeComplexWeb.Telemetry
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  scope "/life_complexities", LifeComplexWeb do
    pipe_through [:browser]

    live "/", LifeComplexityLive.Index, :index
    live "/new", LifeComplexityLive.Index, :new
    live "/:id/edit", LifeComplexityLive.Index, :edit

    live "/:id", LifeComplexityLive.Show, :show
    live "/:id/show/edit", LifeComplexityLive.Show, :edit
  end

  ## Authentication routes

  scope "/", LifeComplexWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LifeComplexWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LifeComplexWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LifeComplexWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", LifeComplexWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LifeComplexWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
