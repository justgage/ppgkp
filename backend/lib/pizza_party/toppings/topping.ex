defmodule PizzaParty.Toppings.Topping do
  use Ecto.Schema
  import Ecto.Changeset
  alias PizzaParty.Pizzas.Pizza

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "toppings" do
    field(:name, :string)
    many_to_many(:pizzas, Pizza, join_through: "pizzas_toppings")

    timestamps()
  end

  @doc false
  def changeset(topping, attrs) do
    topping
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:pizzas)
    |> unique_constraint(:name)
  end
end
