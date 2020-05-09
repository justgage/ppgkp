import React, { useState } from 'react';
import gql from 'graphql-tag';
import _ from 'lodash';

import { useQuery, useMutation } from '@apollo/react-hooks';
import { Link } from 'react-router-dom';

const GET_PIZZAS = gql`
  query pizzas {
    pizzas {
      id
      name
      toppings {
        id
        name
      }
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

const DELETE_PIZZA = gql`
  mutation deletePizza($id: UUID!) {
    deletePizza(id: $id) {
      id
    }
  }
`;

const HomePage = () => {
  const { data, loading, error } = useQuery(GET_PIZZAS);
  const [name, updateName] = useState('');
  const [createPizza] = useMutation(CREATE_PIZZA, {
    variables: { name: name },
  });

  const [deletePizza] = useMutation(DELETE_PIZZA);

  if (loading)
    return (
      <div className="w-screen h-screen flex items-center justify-center">
        Loading...
      </div>
    );
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;
  const { pizzas } = data;

  const nameTaken = pizzas.some((p) => p.name == name);

  return (
    <div className="m-4">
      <nav className="flex items-baseline p-2 border-b mb-2">
        <h1 className="text-2xl">Pizza Party</h1>
        <div className="flex-grow" />
        <Link className="border p-2" to="/settings">
          Settings
        </Link>
      </nav>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (!nameTaken) {
            updateName('');
            createPizza({
              refetchQueries: [{ query: GET_PIZZAS }],
            });
          }
        }}
        className="mb-2"
      >
        <input
          type="text"
          placeholder="Person the Pizza is for"
          className={`border border-black p-2 ${
            nameTaken ? 'border-red-500' : 'border-black'
          }`}
          value={name}
          onChange={(e) => updateName(e.target.value)}
        />
        <button
          className="border border-black p-2 -ml-1 bg-green-100 hover:bg-green-200"
          type="submit"
        >
          Create Pizza 👨🏻‍🍳
        </button>
        {nameTaken && <div class="text-red-500 italic">Name taken</div>}
      </form>
      <div className="mb-16">
        {data.pizzas.map((pizza, i) => {
          const colorClass =
            (data.pizzas.length - i) % 2 == 0
              ? 'bg-blue-100 hover:bg-blue-200'
              : 'bg-yellow-100  hover:bg-yellow-200';
          const toppings = pizza.toppings.map((t) => t.name).join(', ');
          return (
            <div className={`${colorClass} pointer flex items-stretch mb-2`}>
              <Link
                className="p-4 flex flex-grow"
                key={pizza.id}
                to={`/pizza/${pizza.id}`}
              >
                🍕 <strong>{pizza.name}</strong>
                <span className="inline-block mx-2">👉</span>
                <em>
                  {toppings == '' ? (
                    <div className="text-gray-500">(no toppings)</div>
                  ) : (
                    toppings
                  )}
                </em>
                <div className="flex-grow" />
              </Link>
              <button
                className="p-2 hover:bg-red-100 hover:text-red-500"
                onClick={(e) => {
                  deletePizza({
                    variables: { id: pizza.id },
                    refetchQueries: [{ query: GET_PIZZAS }],
                  });
                }}
              >
                cancel order
              </button>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default HomePage;
