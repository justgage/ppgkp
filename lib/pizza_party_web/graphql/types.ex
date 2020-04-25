defmodule PizzaParty.GraphQL.Types do
  @moduledoc """
  GraphQL types for PizzaParty
  """
  use Absinthe.Schema.Notation
  import_types(PizzaParty.GraphQL.Scalars.UUID)

  # --------------------------------------------------------------
  # Object Types
  # --------------------------------------------------------------

  object :topping do
    field :id, :uuid
    field :name, :string
  end
end
