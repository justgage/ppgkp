defmodule PizzaPartyWeb.GraphQL.CreateToppingTest do
  use PizzaPartyWeb.ConnCase

  describe "mutation createTopping" do
    test "can a topping in the database", %{conn: conn} do
      query = """
      mutation createTopping($name: String!){
        createTopping(name: $name) { id name }
      }
      """

      assert %{
               "data" => %{"createTopping" => %{"name" => "mushrooms"}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "mushrooms"}})
               |> json_response(200)
    end

    test "cannot create two toppings with the same name", %{conn: conn} do
      query = """
      mutation createTopping($name: String!){
        createTopping(name: $name) { id name }
      }
      """

      assert %{"data" => %{"createTopping" => %{"name" => "mushrooms"}}} =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "mushrooms"}})
               |> json_response(200)

      assert %{
               "data" => %{"createTopping" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "[name: {\"has already been taken\", []}]",
                   "path" => ["createTopping"]
                 }
               ]
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{name: "mushrooms"}})
               |> json_response(200)
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
