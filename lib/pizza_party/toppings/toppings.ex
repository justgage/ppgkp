defmodule PizzaParty.Toppings do
  @moduledoc """
  The Toppings context.
  """

  import Ecto.Query, warn: false
  alias PizzaParty.Repo

  alias PizzaParty.Toppings.Topping

  @doc """
  Returns the list of topping.

  ## Examples

      iex> list_topping()
      [%Topping{}, ...]

  """
  def list_topping do
    Repo.all(Topping)
  end

  @doc """
  Gets a single topping.

  Raises `Ecto.NoResultsError` if the Topping does not exist.

  ## Examples

      iex> get_topping!(123)
      %Topping{}

      iex> get_topping!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topping!(id), do: Repo.get!(Topping, id)

  def get_topping(id), do: Repo.get(Topping, id)

  @doc """
  Creates a topping.

  ## Examples

      iex> create_topping(%{field: value})
      {:ok, %Topping{}}

      iex> create_topping(%{field: bad_value})
      {:error, String.t()}

  """
  def create_topping(attrs \\ %{}) do
    with {:error, %{errors: errors}} <-
           %Topping{}
           |> Topping.changeset(attrs)
           |> Repo.insert() do
      {:error, inspect(errors)}
    end
  end

  @doc """
  Updates a topping.

  ## Examples

      iex> update_topping(topping, %{field: new_value})
      {:ok, %Topping{}}

      iex> update_topping(topping, %{field: bad_value})
      {:error, String.t()}

  """
  def update_topping(%Topping{} = topping, attrs) do
    topping
    |> Topping.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topping.

  ## Examples

      iex> delete_topping(topping)
      {:ok, %Topping{}}

      iex> delete_topping(topping)
      {:error, String.t()}

  """
  def delete_topping(%Topping{} = topping) do
    Repo.delete(topping)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topping changes.

  ## Examples

      iex> change_topping(topping)
      %Ecto.Changeset{source: %Topping{}}

  """
  def change_topping(%Topping{} = topping) do
    Topping.changeset(topping, %{})
  end

  def pizzas(%Topping{} = topping) do
    Repo.preload(topping, :pizzas)
  end
end
