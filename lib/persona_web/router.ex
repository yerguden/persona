defmodule PersonaWeb.Router do
  use PersonaWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PersonaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  defp admin_auth(conn, _opts) do
    username = System.fetch_env!("ADMIN_USERNAME")
    password = System.fetch_env!("ADMIN_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  scope "/", PersonaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/admin", PersonaWeb do
    pipe_through [:browser, :admin_auth]

    live "/files", AdminLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", PersonaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:persona, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PersonaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
