defmodule Leleglish.Repo do
  use Ecto.Repo,
    otp_app: :leleglish,
    adapter: Ecto.Adapters.Postgres
end
