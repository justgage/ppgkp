import React from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { ApolloProvider } from '@apollo/react-hooks';
import PizzaPage from './PizzaPage';
import HomePage from './HomePage';

const cache = new InMemoryCache();
const link = new HttpLink({
  uri: 'http://localhost:4111/graphql/api',
});

const client = new ApolloClient({
  cache,
  link,
});

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
