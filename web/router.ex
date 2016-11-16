defmodule Inventory.Router do
  use Inventory.Web, :router

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json-api", "json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Inventory.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      post "/register", RegistrationController, :create
      post "/token", SessionController, :create, as: :login
    end
  end

  scope "/api", Inventory.Api, as: :api do
    pipe_through :api_auth

    scope "/v1", V1, as: :v1 do
      get "/user/current", UserController, :current
      resources "/rooms", RoomController, except: [:new, :edit]
    end
  end
end

