defmodule PizzaPartyWeb.PageController do
  use PizzaPartyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
