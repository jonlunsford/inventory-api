defmodule Inventory.Router do
  use Inventory.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api", "json"]
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug JaSerializer.ContentTypeNegotiation
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Inventory do
    pipe_through :browser

    get "/", RegistrationController, :new
    post "/register", RegistrationController, :create

    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/api", Inventory.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      post "/register", RegistrationController, :create
      post "/token", SessionController, :create, as: :login
      options "/token", SessionController, :create, as: :login
    end
  end

  scope "/api", Inventory.Api, as: :api do
    pipe_through :api
    pipe_through :api_auth

    scope "/v1", V1, as: :v1 do
      get "/users/current", UserController, :current

      resources "/users", UserController, only: [:show, :index, :delete] do

        resources "/companies", CompanyController, only: [:index], as: :companies do
          resources "/categories", CategoryController, only: [:index], as: :categories
        end

        resources "/rooms", RoomController, only: [:index], as: :rooms do
          get "/messages", MessageController, :index, as: :messages
        end
      end

      resources "/products", ProductController, except: [:edit] do
        resources "/inputs", InputController, only: [:index], as: :inputs
      end

      resources "/categories", CategoryController, except: [:new, :edit] do
        resources "/products", ProductController, only: [:index], as: :products
        resources "/inputs", InputController, only: [:index], as: :inputs
      end


      resources "/companies", CompanyController, except: [:new, :edit] do
        resources "/address", AddressController, only: [:index], as: :address
      end

      resources "/inputs", InputController, except: [:new, :edit] do
        resources "/address", AddressController, only: [:index], as: :address
      end

      resources "/addresses", AddressController, except: [:new, :edit]
      resources "/rooms", RoomController, except: [:new, :edit]
      resources "/messages", MessageController, except: [:new, :edit]
    end
  end
end

