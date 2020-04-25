defmodule PizzaParty.GraphQL.Schema do
  @moduledoc """
  GraphQL schema for Anakin
  """
  use Absinthe.Schema
  require Logger
  alias PizzaParty.Toppings
  alias PizzaParty.Toppings.Topping

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

    field :delete_topping, type: :topping do
      arg(:id, non_null(:uuid))

      resolve(fn %{id: id}, _info ->
        with topping = %Topping{} <- Toppings.get_topping(id) do
          Toppings.delete_topping(topping)
        else
          other -> {:error, "Unable to delete because of: #{inspect(other)}"}
        end
      end)
    end

    field :update_topping, type: :topping do
      arg(:id, non_null(:uuid))
      arg(:name, non_null(:string))

      resolve(fn updates = %{id: id}, _info ->
        with topping = %Topping{} <- Toppings.get_topping(id) do
          Toppings.update_topping(topping, updates)
        else
          other -> {:error, "Unable to update because of: #{inspect(other)}"}
        end
      end)
    end
  end
end
