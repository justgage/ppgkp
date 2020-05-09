defmodule PizzaParty.Pizzas do
  @moduledoc """
  The Pizzas context.
  """

  import Ecto.Query, warn: false
  alias PizzaParty.Repo

  alias PizzaParty.Pizzas.Pizza
  alias PizzaParty.Toppings.Topping

  @toppings_join_table "pizzas_toppings"

  @doc """
  Returns the list of pizzas.

  ## Examples

      iex> list_pizzas()
      [%Pizza{}, ...]

  """
  def list_pizzas do
    Repo.all(from(p in Pizza, order_by: [desc: p.inserted_at], preload: [:toppings]))
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
  def get_pizza!(id), do: Repo.get!(toppings(Pizza), id)
  def get_pizza(id), do: Repo.get(toppings(Pizza), id)

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

  def toppings(query) do
    from(query, preload: [:toppings])
  end

  def batch_toppings(_, pizza_string_ids) do
    pizza_ids = uuid_binaries(pizza_string_ids)

    from(pt in @toppings_join_table,
      join: t in Topping,
      on: t.id == pt.topping_id,
      where: pt.pizza_id in ^pizza_ids,
      select: t
    )
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
  end

  def add_toppings(pizza_id, topping_ids) do
    with {:ok, pizza_id} <- Ecto.UUID.dump(pizza_id) do
      topping_id_binaries = uuid_binaries(topping_ids)

      records =
        Enum.map(topping_id_binaries, fn topping_id ->
          %{pizza_id: pizza_id, topping_id: topping_id}
        end)

      Repo.insert_all(@toppings_join_table, records)
    end
  end

  def remove_toppings(pizza_id, topping_ids) do
    with {:ok, pizza_id_binary} <- Ecto.UUID.dump(pizza_id) do
      topping_id_binaries = uuid_binaries(topping_ids)

      Repo.delete_all(
        from(pt in @toppings_join_table,
          where: pt.pizza_id == ^pizza_id_binary,
          where: pt.topping_id in ^topping_id_binaries
        )
      )
    end
  end

  defp uuid_binaries(string_uuids) do
    Enum.flat_map(
      string_uuids,
      &case Ecto.UUID.dump(&1) do
        {:ok, uuid} -> [uuid]
        {:error, _} -> []
      end
    )
  end
end
