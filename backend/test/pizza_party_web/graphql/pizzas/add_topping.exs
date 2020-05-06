defmodule PizzaPartyWeb.GraphQL.AddToppingPizzaTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.{Pizzas, Toppings}

  describe "mutation addToppings" do
    test "can a pizza in the database", %{conn: conn} do
      query = """
      mutation addToppings($pizza_id: UUID!, $topping_ids: UUID!){
        addToppings(pizzaId: $pizza_id, toppingIds: $topping_ids) {
          __typename
          name
          toppings { __typename name }
        }
      }
      """

      {:ok, pizza} = Pizzas.create_pizza(%{name: "My Pizza"})
      {:ok, topping} = Toppings.create_topping(%{name: "mushrooms"})

      assert %{
               "data" => %{
                 "addToppings" => %{
                   "name" => "My Pizza",
                   "toppings" => [%{"name" => "mushrooms"}]
                 }
               }
             } =
               conn
               |> post("/graphql/api", %{
                 query: query,
                 variables: %{pizza_id: pizza.id, topping_ids: [topping.id]}
               })
               |> json_response(200)
    end
  end
end
