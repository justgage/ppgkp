defmodule PizzaPartyWeb.Router do
  use PizzaPartyWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug)

    plug(Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Jason
    )
  end

  scope "/", PizzaPartyWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/graphql" do
    pipe_through(:api)
    forward("/api", Absinthe.Plug, schema: PizzaParty.GraphQL.Schema)

    forward(
      "/docs",
      Absinthe.Plug.GraphiQL,
      schema: PizzaParty.GraphQL.Schema,
      interface: :simple
    )
  end
end
