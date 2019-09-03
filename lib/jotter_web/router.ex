defmodule JotterWeb.Router do
  use JotterWeb, :router

  scope "/" do
    pipe_through :api

  forward "/graphiql",
    Absinthe.Plug.GraphiQL,
    schema: JotterWeb.Schema
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug JotterWeb.Plugs.Context
  end

  # scope "/api" do
  #   pipe_through :api

  #   forward "/graphql",
  #     Absinthe.Plug,
  #     schema: JotterWeb.Schema

  #     if Mix.env() == :dev do
  #       forward "/graphiql",
  #       Absinthe.Plug.GraphiQL,
  #       schema: JotterWeb.Schema
  #     end
  # end
end
