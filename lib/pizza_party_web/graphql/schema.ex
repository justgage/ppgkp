defmodule PizzaParty.GraphQL.Schema do
  @moduledoc """
  GraphQL schema for Anakin
  """
  use Absinthe.Schema
  require Logger

  import_types(PizzaParty.GraphQL.Types)
  import_types(PizzaParty.GraphQL.Scalars.UUID)

  query do
    @desc "Fetch pizza order status"
    field :pizza_orders, type: list_of(:pizza_order) do
      arg(:id, :uuid)

      resolve(fn %{}, _info -> {:ok, [%{status: :not_started}]} end)
    end
  end
end
