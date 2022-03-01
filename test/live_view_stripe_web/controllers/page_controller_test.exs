defmodule LiveviewStripeWeb.PageControllerTest do
  use LiveViewStripeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Plans & Pricing"
  end
end
