import React from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';

import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { ApolloProvider } from '@apollo/react-hooks';
import PizzaPage from './PizzaPage';
import HomePage from './HomePage';
import SettingsPage from './SettingsPage';

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
          <Route path="/settings">
            <SettingsPage />
          </Route>
          <Route path="/pizza/:id">
            <PizzaPage />
          </Route>
          <Route exact path="/">
            <HomePage />
          </Route>

          <Route>
            <h1>404: Page not found</h1>
            <Link to="/">Go back</Link>
          </Route>
        </Switch>
      </ApolloProvider>
    </Router>
  );
};
