defmodule PizzaPartyWeb.GraphQL.DeletePizzaTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Pizzas

  describe "mutation deletePizza" do
    test "can a pizza in the database", %{conn: conn} do
      query = """
      mutation deletePizza($id: String!){
        deletePizza(id: $id) { id id }
      }
      """

      {:ok, %{id: id}} = Pizzas.create_pizza(%{name: "pineapple"})

      assert %{
               "data" => %{"deletePizza" => %{"id" => id}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{id: id}})
               |> json_response(200)
    end
  end
end
