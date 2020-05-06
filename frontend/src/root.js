import React, { Fragment } from 'react';
import gql from 'graphql-tag';

import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { useQuery, ApolloProvider } from '@apollo/react-hooks';

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
      toppings {
        id
        name
      }
    }

    toppings {
      name
    }
  }
`;

const HomePage = () => {
  const { data, loading, error } = useQuery(GET_PIZZAS);

  if (loading) return <div>Loading...</div>;
  if (error) return <p>ERROR</p>;
  if (!data) return <p>Not found</p>;

  return JSON.stringify(data);
};

export default () => {
  return (
    <ApolloProvider client={client}>
      <HomePage />
    </ApolloProvider>
  );
};
