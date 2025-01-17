defmodule PizzaParty.Repo.Migrations.CreateTopping do
  use Ecto.Migration

  def change do
    create table(:toppings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      timestamps()
    end

    create(unique_index(:toppings, [:name]))
  end
end
