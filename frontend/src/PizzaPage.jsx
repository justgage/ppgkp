import React from 'react';
import gql from 'graphql-tag';
import _ from 'lodash';

import { useQuery, useMutation } from '@apollo/react-hooks';
import { Link, useRouteMatch } from 'react-router-dom';

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

const ADD_TOPPINGS = gql`
  mutation addToppings($pizzaId: UUID!, $toppingIds: [UUID!]!) {
    addToppings(pizzaId: $pizzaId, toppingIds: $toppingIds) {
      id
    }
  }
`;

const REMOVE_TOPPINGS = gql`
  mutation removeToppings($pizzaId: UUID!, $toppingIds: [UUID!]!) {
    removeToppings(pizzaId: $pizzaId, toppingIds: $toppingIds) {
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
  const [removeTopping] = useMutation(REMOVE_TOPPINGS, {
    variables: { pizzaId: id },
    refetchQueries: [{ query: GET_PIZZA, variables: { id } }],
  });

  if (loading)
    return (
      <div className="w-screen h-screen flex items-center justify-center">
        Loading...
      </div>
    );
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;

  const {
    pizza: { toppings: pizzaToppings },
    toppings,
  } = data;

  return (
    <div className="m-4">
      <nav className="flex items-baseline p-2 border-b mb-2">
        <h1 className="text-2xl">
          <Link className="hover:underline" to="/">
            Pizzas
          </Link>{' '}
          → {data.pizza.name}
        </h1>
      </nav>
      <h2 className="text-xl">Toppings:</h2>
      <ul className="list-disc ml-5">
        {toppings.map(({ id: toppingId, name }) => {
          const hasTopping = _.some(pizzaToppings, { id: toppingId });

          return (
            <li key={toppingId}>
              <input
                type="checkbox"
                className="mr-2"
                id={toppingId}
                name={name}
                value={name}
                checked={hasTopping}
                onChange={() => {
                  if (hasTopping) {
                    removeTopping({ variables: { toppingIds: [toppingId] } });
                  } else {
                    addTopping({ variables: { toppingIds: [toppingId] } });
                  }
                }}
              />
              <label htmlFor={toppingId}>{name}</label>
            </li>
          );
        })}
      </ul>
    </div>
  );
};

export default PizzaPage;
