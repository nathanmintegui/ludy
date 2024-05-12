defmodule Ludy.Repo do
  use Ecto.Repo,
    otp_app: :ludy,
    adapter: Ecto.Adapters.Postgres
end
