defmodule PizzaParty.Repo.Migrations.CreatePizzasToppings do
  use Ecto.Migration

  def change do
    create table(:pizzas_toppings) do
      add :pizza_id, references(:pizzas, type: :binary_id)
      add :topping_id, references(:toppings, type: :binary_id)
    end

    create unique_index(:pizzas_toppings, [:pizza_id, :topping_id])
  end
end
