defmodule PizzaParty.PizzasTest do
  use PizzaParty.DataCase

  alias PizzaParty.Pizzas
  alias PizzaParty.Pizzas.Pizza
  alias PizzaParty.Toppings
  alias PizzaParty.Toppings.Topping

  describe "pizzas" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def pizza_fixture(attrs \\ %{}) do
      {:ok, pizza} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pizzas.create_pizza()

      pizza
    end

    test "list_pizzas/0 returns all pizzas" do
      pizza = pizza_fixture()
      assert Pizzas.list_pizzas() == [%{pizza | toppings: []}]
    end

    test "get_pizza!/1 returns the pizza with given id" do
      pizza = pizza_fixture()
      assert Pizzas.get_pizza!(pizza.id).id == pizza.id
    end

    test "create_pizza/1 with valid data creates a pizza" do
      assert {:ok, %Pizza{} = pizza} = Pizzas.create_pizza(@valid_attrs)
      assert pizza.name == "some name"
    end

    test "create_pizza/1 with invalid data returns error changeset" do
      assert {:error, "[name: {\"can't be blank\", [validation: :required]}]"} =
               Pizzas.create_pizza(@invalid_attrs)
    end

    test "update_pizza/2 with valid data updates the pizza" do
      pizza = pizza_fixture()
      assert {:ok, pizza} = Pizzas.update_pizza(pizza, @update_attrs)
      assert %Pizza{} = pizza
      assert pizza.name == "some updated name"
    end

    test "update_pizza/2 with invalid data returns error changeset" do
      pizza = pizza_fixture()
      assert {:error, %Ecto.Changeset{}} = Pizzas.update_pizza(pizza, @invalid_attrs)
      assert %{pizza | toppings: []} == Pizzas.get_pizza!(pizza.id)
    end

    test "delete_pizza/1 deletes the pizza" do
      pizza = pizza_fixture()
      assert {:ok, %Pizza{}} = Pizzas.delete_pizza(pizza)
      assert_raise Ecto.NoResultsError, fn -> Pizzas.get_pizza!(pizza.id) end
    end

    test "change_pizza/1 returns a pizza changeset" do
      pizza = pizza_fixture()
      assert %Ecto.Changeset{} = Pizzas.change_pizza(pizza)
    end

    test "add_toppings/2 with valid data creates an association" do
      assert {:ok, %Pizza{} = pizza} = Pizzas.create_pizza(@valid_attrs)
      assert {:ok, %Topping{} = topping} = Toppings.create_topping(%{name: "mushrooms"})
      Pizzas.add_toppings(pizza.id, [topping.id])

      assert %PizzaParty.Pizzas.Pizza{
               name: "some name",
               toppings: [
                 %PizzaParty.Toppings.Topping{
                   name: "mushrooms"
                 }
               ]
             } = Pizzas.get_pizza!(pizza.id)
    end
  end
end
