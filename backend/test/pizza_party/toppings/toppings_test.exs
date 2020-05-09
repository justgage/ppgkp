defmodule PizzaParty.ToppingsTest do
  use PizzaParty.DataCase

  alias PizzaParty.Toppings

  describe "topping" do
    alias PizzaParty.Toppings.Topping

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def topping_fixture(attrs \\ %{}) do
      {:ok, topping} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Toppings.create_topping()

      topping
    end

    test "list_topping/0 returns all topping" do
      topping = topping_fixture()
      assert Toppings.list_topping() == [topping]
    end

    test "get_topping!/1 returns the topping with given id" do
      topping = topping_fixture()
      assert Toppings.get_topping!(topping.id) == topping
    end

    test "create_topping/1 with valid data creates a topping" do
      assert {:ok, %Topping{} = topping} = Toppings.create_topping(@valid_attrs)
      assert topping.name == "some name"
    end

    test "create_topping/1 with invalid data returns error changeset" do
      assert {:error, "[name: {\"can't be blank\", [validation: :required]}]"} =
               Toppings.create_topping(@invalid_attrs)
    end

    test "update_topping/2 with valid data updates the topping" do
      topping = topping_fixture()
      assert {:ok, topping} = Toppings.update_topping(topping, @update_attrs)
      assert %Topping{} = topping
      assert topping.name == "some updated name"
    end

    test "update_topping/2 with invalid data returns error changeset" do
      topping = topping_fixture()
      assert {:error, %Ecto.Changeset{}} = Toppings.update_topping(topping, @invalid_attrs)
      assert topping == Toppings.get_topping!(topping.id)
    end

    test "delete_topping/1 deletes the topping" do
      topping = topping_fixture()
      assert :ok = Toppings.delete_topping(topping.id)
      assert_raise Ecto.NoResultsError, fn -> Toppings.get_topping!(topping.id) end
    end

    test "change_topping/1 returns a topping changeset" do
      topping = topping_fixture()
      assert %Ecto.Changeset{} = Toppings.change_topping(topping)
    end
  end
end
