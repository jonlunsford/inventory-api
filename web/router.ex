defmodule Inventory.Router do
  use Inventory.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/api", Inventory.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/session", SessionController, only: [:index]
    end
  end
end
