defmodule PizzaPartyWeb.GraphQL.GetToppingsTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Toppings

  describe "query getTopping" do
    test "get multiple from the database", %{conn: conn} do
      query = """
      query {
        toppings { id name }
      }
      """

      name1 = Ecto.UUID.generate()
      {:ok, %{id: id1}} = Toppings.create_topping(%{name: name1})

      name2 = Ecto.UUID.generate()
      {:ok, %{id: id2}} = Toppings.create_topping(%{name: name2})

      assert conn
             |> post("/graphql/api", %{query: query})
             |> json_response(200) == %{
               "data" => %{
                 "toppings" => [
                   %{"id" => id1, "name" => name1},
                   %{"id" => id2, "name" => name2}
                 ]
               }
             }
    end

    test "returns nothing if nothing in the database", %{conn: conn} do
      query = """
      query {
        toppings { name }
      }
      """

      assert conn
             |> post("/graphql/api", %{query: query})
             |> json_response(200) == %{
               "data" => %{
                 "toppings" => []
               }
             }
    end
  end
end
