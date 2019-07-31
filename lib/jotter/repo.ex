defmodule Jotter.Repo do
  use Ecto.Repo,
    otp_app: :jotter,
    adapter: Ecto.Adapters.Postgres
end
