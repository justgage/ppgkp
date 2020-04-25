defmodule PizzaParty.GraphQL.Types do
  @moduledoc """
  GraphQL types for PizzaParty
  """
  use Absinthe.Schema.Notation

  # --------------------------------------------------------------
  # Object Types
  # --------------------------------------------------------------

  object :pizza_order do
    field :status, :status
  end

  enum :status do
    value(:not_started)
    value(:baking)
    value(:delivered)
  end
end
