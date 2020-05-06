import React, { Fragment, useState } from 'react';
import gql from 'graphql-tag';
import _ from 'lodash';

import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { useQuery, ApolloProvider, useMutation } from '@apollo/react-hooks';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
} from 'react-router-dom';

const cache = new InMemoryCache();
const link = new HttpLink({
  uri: 'http://localhost:4111/graphql/api',
});

const client = new ApolloClient({
  cache,
  link,
});

const GET_PIZZAS = gql`
  query pizzas {
    pizzas {
      id
      name
    }
  }
`;

const GET_PIZZA = gql`
  query getPizza($id: UUID!) {
    pizza(id: $id) {
      id
      name
      toppings {
        id
        name
      }
    }
    toppings {
      id
      name
    }
  }
`;

const CREATE_PIZZA = gql`
  mutation createPizza($name: String!) {
    createPizza(name: $name) {
      id
      name
      toppings {
        id
        name
      }
    }
  }
`;

const ADD_TOPPINGS = gql`
  mutation addToppings($pizzaId: UUID!, $toppingIds: [UUID!]!) {
    addToppings(pizzaId: $pizzaId, toppingIds: $toppingIds) {
      id
    }
  }
`;

const PizzaPage = () => {
  const {
    params: { id },
  } = useRouteMatch();

  const { data, loading, error } = useQuery(GET_PIZZA, { variables: { id } });
  const [addTopping] = useMutation(ADD_TOPPINGS, {
    variables: { pizzaId: id },
    refetchQueries: [{ query: GET_PIZZA, variables: { id } }],
  });

  console.log(data, loading, error);
  if (loading) return <div>Loading...</div>;
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;

  const {
    pizza: { toppings: pizzaToppings },
    toppings,
  } = data;

  console.log(toppings, pizzaToppings);

  return (
    <div className="m-4">
      <h1 className="text-2xl">
        <Link to="/">Pizzas</Link> → {data.pizza.name}
      </h1>
      <h2 className="text-xl">Toppings:</h2>
      <ul>
        {toppings.map(({ id: toppingId, name }) => {
          const hasTopping = _.some(pizzaToppings, { id: toppingId });

          return (
            <li key={toppingId}>
              <input
                type="checkbox"
                id={toppingId}
                name={name}
                value={name}
                checked={hasTopping}
                onChange={() =>
                  addTopping({ variables: { toppingIds: [toppingId] } })
                }
              />
              <label htmlFor={id}>{name}</label>
            </li>
          );
        })}
      </ul>
    </div>
  );
};

const HomePage = () => {
  const { data, loading, error } = useQuery(GET_PIZZAS);
  const [name, updateName] = useState('');
  const [createPizza] = useMutation(CREATE_PIZZA, {
    variables: { name: name },
  });

  if (loading) return <div>Loading...</div>;
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;

  console.log(data);
  return (
    <div className="m-4">
      <h1 className="text-2xl">Pizzas</h1>
      <form onSubmit={() => createPizza()}>
        <input
          type="text"
          placeholder="New Pizza Name"
          class=""
          onChange={(e) => updateName(e.target.value)}
        />
        <button type="submit">Create New Pizza</button>
      </form>
      <div class="flex">
        {data.pizzas.map((pizza) => {
          return (
            <Link
              className="bg-blue-100 p-4 items-center justify-center w-64 h-64 hover:bg-blue-200 pointer block mr-2"
              key={pizza.id}
              to={`/pizza/${pizza.id}`}
            >
              {pizza.name}
            </Link>
          );
        })}
      </div>
    </div>
  );
};

export default () => {
  return (
    <Router>
      <ApolloProvider client={client}>
        <Switch>
          <Route path="/pizza/:id">
            <PizzaPage />
          </Route>
          <Route path="/">
            <HomePage />
          </Route>
        </Switch>
      </ApolloProvider>
    </Router>
  );
};
