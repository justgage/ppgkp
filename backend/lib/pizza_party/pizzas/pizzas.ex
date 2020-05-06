defmodule PizzaParty.Pizzas do
  @moduledoc """
  The Pizzas context.
  """

  import Ecto.Query, warn: false
  alias PizzaParty.Repo

  alias PizzaParty.Pizzas.Pizza
  alias PizzaParty.Toppings.Topping

  @doc """
  Returns the list of pizzas.

  ## Examples

      iex> list_pizzas()
      [%Pizza{}, ...]

  """
  def list_pizzas do
    Repo.all(Pizza)
  end

  @doc """
  Gets a single pizza.

  Raises `Ecto.NoResultsError` if the Pizza does not exist.

  ## Examples

      iex> get_pizza!(123)
      %Pizza{}

      iex> get_pizza!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pizza!(id), do: Repo.get!(Pizza, id)
  def get_pizza(id), do: Repo.get(Pizza, id)

  @doc """
  Creates a pizza.

  ## Examples

      iex> create_pizza(%{field: value})
      {:ok, %Pizza{}}

      iex> create_pizza(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pizza(attrs \\ %{}) do
    with {:error, %{errors: errors}} <-
           %Pizza{}
           |> Pizza.changeset(attrs)
           |> Repo.insert() do
      {:error, inspect(errors)}
    end
  end

  @doc """
  Updates a pizza.

  ## Examples

      iex> update_pizza(pizza, %{field: new_value})
      {:ok, %Pizza{}}

      iex> update_pizza(pizza, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pizza(%Pizza{} = pizza, attrs) do
    pizza
    |> Pizza.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Pizza.

  ## Examples

      iex> delete_pizza(pizza)
      {:ok, %Pizza{}}

      iex> delete_pizza(pizza)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pizza(%Pizza{} = pizza) do
    Repo.delete(pizza)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pizza changes.

  ## Examples

      iex> change_pizza(pizza)
      %Ecto.Changeset{source: %Pizza{}}

  """
  def change_pizza(%Pizza{} = pizza) do
    Pizza.changeset(pizza, %{})
  end

  def toppings(%Pizza{} = pizza) do
    Repo.preload(pizza, :toppings)
  end

  def add_topping(%Pizza{} = pizza, %Topping{} = topping) do
    pizza_with_toppings =
      toppings(pizza)
      |> IO.inspect(
        label:
          ~s|\n\n\nDEBUGGING: ~/personal/pizza_party/backend/lib/pizza_party/pizzas/pizzas.ex:115\n\t|
      )

    topping
    |> IO.inspect(
      label:
        ~s|\n\n\nDEBUGGING: ~/personal/pizza_party/backend/lib/pizza_party/pizzas/pizzas.ex:122\n\t|
    )

    pizza_with_toppings
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(
      :toppings,
      Enum.uniq_by([topping | pizza_with_toppings.toppings], fn topping -> topping.name end)
    )
    |> Repo.update()
  end
end
