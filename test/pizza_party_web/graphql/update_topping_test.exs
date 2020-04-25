defmodule PizzaPartyWeb.GraphQL.UpdateToppingTest do
  use PizzaPartyWeb.ConnCase
  alias PizzaParty.Toppings

  describe "mutation updateTopping" do
    test "can update a topping in the database", %{conn: conn} do
      query = """
      mutation updateTopping($id: UUID!, $name: String!){
        updateTopping(id: $id, name: $name) { id name }
      }
      """

      name1 = Ecto.UUID.generate()
      {:ok, %{id: id1}} = Toppings.create_topping(%{name: name1})

      name_new = Ecto.UUID.generate()

      assert %{
               "data" => %{"updateTopping" => %{"name" => name_new}}
             } =
               conn
               |> post("/graphql/api", %{query: query, variables: %{id: id1, name: name_new}})
               |> json_response(200)
    end
  end

  test "cannot update a topping name to nil in the database", %{conn: conn} do
    query = """
    mutation updateTopping($id: UUID!, $name: String!){
      updateTopping(id: $id, name: $name) { id name }
    }
    """

    name1 = Ecto.UUID.generate()
    {:ok, %{id: id1}} = Toppings.create_topping(%{name: name1})

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
