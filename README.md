# PizzaParty Code Review Submission

## Getting Started

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.create && mix ecto.migrate`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4111/graphql/docs`](http://localhost:4111/graphql/docs) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

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

- [ ] It should have an API end point for creating a new pizza
- [ ] It should have an API end point for getting a list of existing pizzas
- [ ] It should have an API end point to delete an existing pizza
- [ ] It should have an API to update an existing pizza
- [ ] It should not allow duplicate pizzas

### Pizza Toppings API

As a pizza application maker I should be able to view/add/remove toppings from my pizza creations.

- [ ] It should have an API end point to add an existing topping to a pizza
- [ ] It should have an API end point to remove a topping from a pizza
- [ ] It should have an API end point to view toppings for a pizza

_Bonus:_ Make API documentation publicly available.

## Front End Stories

### Manage Toppings

As a pizza operation manager I should be able to manage toppings available for my pizza chefs.

- [ ] It should allow me to see a list of available toppings
- [ ] It should allow me to add a new topping
- [ ] It should allow me to delete an existing topping

### Manage Pizzas

As a pizza chef I should be able to create new pizza master pieces

- [ ] It should allow me to see a list of existing pizzas and their toppings
- [ ] It should allow me to allow me to create a new pizza and add toppings to it
- [ ] It should allow me to allow me to delete an existing pizza

# Learn more

- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
