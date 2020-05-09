defmodule PizzaPartyWeb.GraphQL.DeleteToppingTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Toppings

  describe "mutation deleteTopping" do
    test "can a topping in the database", %{conn: conn} do
      query = """
      mutation deleteTopping($id: String!){
        deleteTopping(id: $id)
      }
      """

      {:ok, %{id: id}} = Toppings.create_topping(%{name: "pineapple"})

      assert %{id: ^id} = Toppings.get_topping(id)

      assert %{
               "data" => %{"deleteTopping" => "deleted"}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{id: id}})
               |> json_response(200)

      assert nil == Toppings.get_topping(id)
    end
  end
end
