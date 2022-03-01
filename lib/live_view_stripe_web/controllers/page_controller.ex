defmodule LiveViewStripeWeb.PageController do
  use LiveViewStripeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
