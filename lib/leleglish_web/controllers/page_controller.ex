defmodule LeleglishWeb.PageController do
  use LeleglishWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
