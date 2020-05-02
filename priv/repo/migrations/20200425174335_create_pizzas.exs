defmodule PizzaParty.Repo.Migrations.CreatePizzas do
  use Ecto.Migration

  def change do
    create table(:pizzas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      timestamps()
    end

    create(unique_index(:pizzas, [:name]))
  end
end
