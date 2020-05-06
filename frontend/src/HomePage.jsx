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
      <form
        onSubmit={(e) => {
          e.preventDefault();
          updateName('');
          createPizza({
            refetchQueries: [{ query: GET_PIZZAS }],
          });
        }}
        className="mb-2"
      >
        <input
          type="text"
          placeholder="New Pizza Name"
          className="border border-black p-2"
          value={name}
          onChange={(e) => updateName(e.target.value)}
        />
        <button
          className="border border-black p-2 ml-1 bg-green-100"
          type="submit"
        >
          Create New Pizza →
        </button>
      </form>
      <div>
        {data.pizzas.map((pizza, i) => {
          const colorClass =
            (data.pizzas.length - i) % 2 == 0 ? 'bg-blue-100' : 'bg-yellow-100';
          const toppings = pizza.toppings.map((t) => t.name).join(', ');
          return (
            <Link
              className={`${colorClass} p-4 hover:bg-blue-200 pointer mb-2 flex`}
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
            </Link>
          );
        })}
      </div>
    </div>
  );
};

export default HomePage;
