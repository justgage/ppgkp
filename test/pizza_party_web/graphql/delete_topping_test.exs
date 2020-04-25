defmodule PizzaPartyWeb.GraphQL.DeleteToppingTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Toppings

  describe "mutation deleteTopping" do
    test "can a topping in the database", %{conn: conn} do
      query = """
      mutation deleteTopping($id: String!){
        deleteTopping(id: $id) { id id }
      }
      """

      {:ok, %{id: id}} = Toppings.create_topping(%{name: "pineapple"})

      assert %{
               "data" => %{"deleteTopping" => %{"id" => id}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{id: id}})
               |> json_response(200)
    end
  end
end
