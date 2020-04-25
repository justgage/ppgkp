defmodule PizzaParty.Toppings.Topping do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "topping" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(topping, attrs) do
    topping
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
