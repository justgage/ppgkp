defmodule PizzaParty.GraphQL.Schema do
  @moduledoc """
  GraphQL schema for Anakin
  """
  use Absinthe.Schema
  require Logger

  alias PizzaParty.Pizzas
  alias PizzaParty.Pizzas.Pizza
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

    field :pizzas, type: list_of(:pizza) do
      resolve(fn %{}, _info ->
        pizzas = Pizzas.list_pizzas()
        {:ok, pizzas}
      end)
    end

    field :pizza, type: :pizza do
      arg(:id, non_null(:uuid))

      resolve(fn %{id: id}, _info ->
        {:ok, Pizzas.get_pizza(id)}
      end)
    end
  end

  mutation do
    # TOPPINGS ----------------------------------------
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

    # PIZZAS ----------------------------------------
    field :create_pizza, type: :pizza do
      arg(:name, :string)

      resolve(fn input, _info ->
        Pizzas.create_pizza(input)
      end)
    end

    field :delete_pizza, type: :pizza do
      arg(:id, non_null(:uuid))

      resolve(fn %{id: id}, _info ->
        with pizza = %Pizza{} <- Pizzas.get_pizza(id) do
          Pizzas.delete_pizza(pizza)
        else
          other -> {:error, "Unable to delete because of: #{inspect(other)}"}
        end
      end)
    end

    field :update_pizza, type: :pizza do
      arg(:id, non_null(:uuid))
      arg(:name, non_null(:string))

      resolve(fn updates = %{id: id}, _info ->
        with pizza = %Pizza{} <- Pizzas.get_pizza(id) do
          Pizzas.update_pizza(pizza, updates)
        else
          other -> {:error, "Unable to update because of: #{inspect(other)}"}
        end
      end)
    end

    field :add_toppings, type: :pizza do
      arg(:pizza_id, non_null(:uuid))
      arg(:topping_ids, non_null(list_of(non_null(:uuid))))

      resolve(fn %{pizza_id: id, topping_ids: topping_ids}, _info ->
        Pizzas.add_toppings(id, topping_ids)

        with pizza = %Pizza{} <- Pizzas.get_pizza(id) do
          {:ok, pizza}
        else
          other -> {:error, "Unable to update because of: #{inspect(other)}"}
        end
      end)
    end

    field :remove_toppings, type: :pizza do
      arg(:pizza_id, non_null(:uuid))
      arg(:topping_ids, non_null(list_of(non_null(:uuid))))

      resolve(fn %{pizza_id: pizza_id, topping_ids: topping_ids}, _info ->
        Pizzas.remove_toppings(pizza_id, topping_ids)
        {:ok, Pizzas.get_pizza(pizza_id)}
      end)
    end
  end
end
