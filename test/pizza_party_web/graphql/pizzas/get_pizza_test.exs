defmodule PizzaPartyWeb.GraphQL.GetPizzasTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Pizzas

  describe "query getPizza" do
    test "get multiple from the database", %{conn: conn} do
      query = """
      query {
        pizzas { id name }
      }
      """

      name1 = Ecto.UUID.generate()
      {:ok, %{id: id1}} = Pizzas.create_pizza(%{name: name1})

      name2 = Ecto.UUID.generate()
      {:ok, %{id: id2}} = Pizzas.create_pizza(%{name: name2})

      assert conn
             |> post("/graphql/api", %{query: query})
             |> json_response(200) == %{
               "data" => %{
                 "pizzas" => [
                   %{"id" => id1, "name" => name1},
                   %{"id" => id2, "name" => name2}
                 ]
               }
             }
    end

    test "returns nothing if nothing in the database", %{conn: conn} do
      query = """
      query {
        pizzas { name }
      }
      """

      assert conn
             |> post("/graphql/api", %{query: query})
             |> json_response(200) == %{
               "data" => %{
                 "pizzas" => []
               }
             }
    end
  end
end
