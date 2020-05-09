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

      {:ok, %{id: id1}} = Pizzas.create_pizza(%{name: "1"})
      {:ok, %{id: id2}} = Pizzas.create_pizza(%{name: "2"})

      assert conn
             |> post("/graphql/api", %{query: query})
             |> json_response(200)
             |> get_in(["data", "pizzas"])
             |> Enum.sort_by(& &1["name"]) == [
               %{"id" => id1, "name" => "1"},
               %{"id" => id2, "name" => "2"}
             ]
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
