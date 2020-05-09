import React, { useState } from 'react';
import gql from 'graphql-tag';
import _ from 'lodash';

import { useQuery, useMutation } from '@apollo/react-hooks';
import { Link, useRouteMatch } from 'react-router-dom';

const GET_TOPPINGS = gql`
  query getToppings {
    toppings {
      id
      name
    }
  }
`;

const CREATE_TOPPINGS = gql`
  mutation createTopping($name: UUID!) {
    createTopping(name: $name) {
      id
    }
  }
`;

const DELETE_TOPPING = gql`
  mutation deleteTopping($toppingId: UUID!) {
    deleteTopping(id: $toppingId)
  }
`;

const SettingsPage = () => {
  const [toppingName, setToppingName] = useState('');
  const { data, loading, error } = useQuery(GET_TOPPINGS);
  const [createTopping] = useMutation(CREATE_TOPPINGS, {
    refetchQueries: [{ query: GET_TOPPINGS }],
  });
  const [deleteTopping] = useMutation(DELETE_TOPPING, {
    refetchQueries: [{ query: GET_TOPPINGS }],
  });

  if (loading)
    return (
      <div className="w-screen h-screen flex items-center justify-center">
        Loading...
      </div>
    );
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;

  const { toppings } = data;

  return (
    <div className="m-4">
      <nav className="flex items-baseline p-2 border-b mb-2">
        <h1 className="text-2xl">
          <Link className="hover:underline" to="/">
            Pizzas
          </Link>
          → Settings
        </h1>
      </nav>

      <h2 className="text-lg">Toppings:</h2>
      <div className="text-red-900 bg-red-300 p-2">
        <strong>Warning: </strong>
        <em>
          deleting any toppings will remove it from all Pizzas and is final!
        </em>
      </div>
      <ul className="list-disc ml-5">
        {toppings.map(({ id: toppingId, name }) => {
          return (
            <li key={toppingId}>
              {name}
              <button
                className="p-2 hover:underline text-gray-500 hover:text-red-500"
                onClick={() =>
                  deleteTopping({
                    variables: {
                      toppingId: toppingId,
                    },
                  })
                }
                alt="delete"
              >
                (delete)
              </button>
            </li>
          );
        })}
      </ul>
      <form
        className="flex w-full border"
        onSubmit={(e) => {
          e.preventDefault();
          createTopping({ variables: { name: toppingName } });
          setToppingName('');
        }}
      >
        <input
          className="flex-grow p-2"
          type="text"
          value={toppingName}
          placeholder="Awesome Sauce"
          onChange={(e) => setToppingName(e.target.value)}
        ></input>
        <input
          className="cursor-pointer text-white bg-green-500 hover:bg-green-600 p-2"
          type="submit"
          value="Create"
        ></input>
      </form>
    </div>
  );
};

export default SettingsPage;
