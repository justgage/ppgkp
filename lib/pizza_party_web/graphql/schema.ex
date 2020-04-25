defmodule PizzaParty.GraphQL.Schema do
  @moduledoc """
  GraphQL schema for Anakin
  """
  use Absinthe.Schema
  require Logger
  alias PizzaParty.Toppings

  import_types(PizzaParty.GraphQL.Types)

  query do
    field :toppings, type: list_of(:topping) do
      arg(:id, :uuid)

      resolve(fn %{}, _info ->
        toppings = Toppings.list_topping()
        {:ok, toppings}
      end)
    end
  end

  mutation do
    @desc "Buy Webchat Pro"
    field :create_topping, type: :topping do
      arg(:name, :string)

      resolve(fn input, _info ->
        Toppings.create_topping(input)
      end)
    end
  end
end
