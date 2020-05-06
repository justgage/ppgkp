defmodule PizzaParty.GraphQL.Types do
  @moduledoc """
  GraphQL types for PizzaParty
  """
  use Absinthe.Schema.Notation
  alias PizzaParty.Pizzas
  import_types(PizzaParty.GraphQL.Scalars.UUID)

  # --------------------------------------------------------------
  # Object Types
  # --------------------------------------------------------------

  object :topping do
    field(:id, :uuid)
    field(:name, :string)
  end

  object :pizza do
    field(:id, :uuid)
    field(:name, :string)

    field :toppings, list_of(:topping) do
      resolve(fn pizza, _, _ ->
        {:ok, Pizzas.toppings(pizza).toppings}
      end)
    end
  end
end
