defmodule PizzaParty.Pizzas.Pizza do
  use Ecto.Schema
  import Ecto.Changeset
  alias PizzaParty.Toppings.Topping

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pizzas" do
    field(:name, :string)
    many_to_many(:toppings, Topping, join_through: "pizzas_toppings")
    timestamps()
  end

  @doc false
  def changeset(pizza, attrs) do
    pizza
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:toppings)
    |> unique_constraint(:name)
  end
end
