defmodule LeleglishWeb.PageControllerTest do
  use LeleglishWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/?video_id=43bXwdYeht4")
    # assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
