defmodule PizzaPartyWeb.GraphQL.UpdatePizzaTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Pizzas

  describe "mutation updatePizza" do
    test "can update a pizza in the database", %{conn: conn} do
      query = """
      mutation updatePizza($id: UUID!, $name: String!){
        updatePizza(id: $id, name: $name) { id name }
      }
      """

      name1 = Ecto.UUID.generate()
      {:ok, %{id: id1}} = Pizzas.create_pizza(%{name: name1})

      name_new = Ecto.UUID.generate()

      assert %{
               "data" => %{"updatePizza" => %{"name" => name_new}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{id: id1, name: name_new}})
               |> json_response(200)
    end
  end

  test "cannot update a pizza name to nil in the database", %{conn: conn} do
    query = """
    mutation updatePizza($id: UUID!, $name: String!){
      updatePizza(id: $id, name: $name) { id name }
    }
    """

    name1 = Ecto.UUID.generate()
    {:ok, %{id: id1}} = Pizzas.create_pizza(%{name: name1})

    name_new = nil

    assert %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Argument \"name\" has invalid value $name."
               },
               %{
                 "locations" => [%{"column" => 0, "line" => 1}],
                 "message" => "Variable \"name\": Expected non-null, found null."
               }
             ]
           } ==
             conn
             |> post("/graphql/api", %{query: query, variables: %{id: id1, name: name_new}})
             |> json_response(200)
  end
end
