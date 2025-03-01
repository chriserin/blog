defmodule BlogWeb.Router do
  use BlogWeb, :router

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

  pipeline :private do
    plug :basic_auth
  end

  scope "/", BlogWeb do
    pipe_through :browser
    pipe_through :basic_auth

    # Creating and editing posts
    get "/posts/:id/edit", PostController, :edit
    get "/posts/new", PostController, :new
    post "/posts", PostController, :create
    put "/posts/:id", PostController, :update
    delete "/posts/:id", PostController, :delete
  end

  scope "/", BlogWeb do
    pipe_through :browser

    # General site links
    get "/", PostController, :index
    get "/posts", PostController, :index
    get "/posts/:id", PostController, :show
    get "/about", PageController, :about
    get "/projects", PageController, :projects
    get "/now", PageController, :now

    # TILS
    get "/tils", TilController, :index
    get "/tils/:id", TilController, :show
    
    # RSS Feed
    get "/feed", FeedController, :index
  end

  def basic_auth(conn, _opts) do
    username = Application.fetch_env!(:blog, :basic_user)
    password = Application.fetch_env!(:blog, :basic_pass)
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
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
      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
