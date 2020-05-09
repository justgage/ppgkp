# PizzaParty Code Review Submission

## Getting Started

To start your Phoenix server:

- go to backend folder `cd backend`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.create && mix ecto.migrate`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4111/graphql/docs`](http://localhost:4111/graphql/docs) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

To start frontend:

- `cd frontend`
- `yarn`
- `yarn start`

# Requirements

## Back End Stories

### Toppings API

As a pizza application maker I should be able to create, read, update and delete pizza toppings.

- [x] It should have an API end point for creating a new topping
- [x] It should have an API end point for getting a list of existing toppings
- [x] It should have an API end point to delete an existing topping
- [x] It should have an API to update an existing topping
- [x] It should now allow duplicate toppings

### Pizza API

As a pizza application maker I should be able to create, read, update and delete pizzas.

- [x] It should have an API end point for creating a new pizza
- [x] It should have an API end point for getting a list of existing pizzas
- [x] It should have an API end point to delete an existing pizza
- [x] It should have an API to update an existing pizza
- [x] It should not allow duplicate pizzas

### Pizza Toppings API

As a pizza application maker I should be able to view/add/remove toppings from my pizza creations.

- [x] It should have an API end point to add an existing topping to a pizza
- [x] It should have an API end point to remove a topping from a pizza
- [x] It should have an API end point to view toppings for a pizza

_Bonus:_ Make API documentation publicly available.

After you've started the server you can look here for some example queries (non-exhaustive) 👉[GraphQL Docs](<http://0.0.0.0:4111/graphql/docs?query=mutation%20createPizza%20%7B%0A%20%20createPizza(name%3A%20%22Gage%27s%20Pizza%22)%20%7B%0A%20%20%20%20id%0A%20%20%7D%0A%7D%0A%0Amutation%20createTopping%20%7B%0A%20%20createTopping(name%3A%20%22Cheese%20(VEGAN)%22)%20%7B%0A%20%20%20%20id%0A%20%20%20%20name%0A%20%20%7D%0A%7D%0A%0Amutation%20deleteGagesPizza%20%7B%0A%20%20deletePizza(id%3A%20%22f1e1acfd-4a34-4318-ad4f-b4acf7df8644%22)%20%7B%0A%20%20%20%20name%0A%20%20%20%20id%0A%20%20%7D%0A%7D%0A%0Amutation%20updateGagesPizza%20%7B%0A%20%20updatePizza(id%3A%20%22f1e1acfd-4a34-4318-ad4f-b4acf7df8644%22%2C%20name%3A%20%22Gage%27s%20special%20Pizza%22)%20%7B%0A%20%20%20%20name%0A%20%20%20%20id%0A%20%20%7D%0A%7D%0A%0Amutation%20addTopping%20%7B%0A%20%20addToppings(pizzaId%3A%20%22d6855a7b-fde0-46b2-abd9-6f1a8f23908e%22%2C%20toppingIds%3A%20%5B%2275d8062f-6000-4b0e-8b70-4895a88a418d%22%5D)%20%7B%0A%20%20%20%20name%0A%20%20%20%20id%0A%20%20%7D%0A%7D%0A%0Aquery%20getAll%20%7B%0A%20%20pizzas%20%7B%0A%20%20%20%20id%0A%20%20%20%20name%0A%20%20%20%20toppings%20%7B%0A%20%20%20%20%20%20id%0A%20%20%20%20%20%20name%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20%0A%20%20toppings%20%7B%0A%20%20%20%20name%0A%20%20%20%20id%0A%20%20%7D%0A%7D>)

If you're unfamiliar with GraphQL I would suggest reading about it on the official website https://graphql.org/.

## Front End Stories

### Manage Toppings

As a pizza operation manager I should be able to manage toppings available for my pizza chefs.

- [x] It should allow me to see a list of available toppings
- [x] It should allow me to add a new topping
- [x] It should allow me to delete an existing topping

### Manage Pizzas

As a pizza chef I should be able to create new pizza master pieces

- [x] It should allow me to see a list of existing pizzas and their toppings
- [x] It should allow me to allow me to create a new pizza and add toppings to it
- [x] It should allow me to allow me to delete an existing pizza

# Learn more

- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
