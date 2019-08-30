defmodule JotterWeb.Router do
  use JotterWeb, :router

  scope "/" do
  forward "/graphiql",
    Absinthe.Plug.GraphiQL,
    schema: JotterWeb.Schema
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # scope "/api", JotterWeb do
  #   pipe_through :api
  # end
end
