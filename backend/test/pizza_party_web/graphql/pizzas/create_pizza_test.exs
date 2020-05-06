defmodule PizzaPartyWeb.GraphQL.CreatePizzaTest do
  use PizzaPartyWeb.ConnCase

  describe "mutation createPizza" do
    test "can a pizza in the database", %{conn: conn} do
      query = """
      mutation createPizza($name: String!){
        createPizza(name: $name) { id name }
      }
      """

      assert %{
               "data" => %{"createPizza" => %{"name" => "Gage's Pizza"}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "Gage's Pizza"}})
               |> json_response(200)
    end

    test "cannot create two pizzas with the same name", %{conn: conn} do
      query = """
      mutation createPizza($name: String!){
        createPizza(name: $name) { id name }
      }
      """

      assert %{"data" => %{"createPizza" => %{"name" => "Gage's Pizza"}}} =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "Gage's Pizza"}})
               |> json_response(200)

      assert %{
               "data" => %{"createPizza" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "[name: {\"has already been taken\", []}]",
                   "path" => ["createPizza"]
                 }
               ]
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "Gage's Pizza"}})
               |> json_response(200)
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
