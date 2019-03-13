defmodule Jetruby.Repo do
  use Ecto.Repo,
    otp_app: :jetruby,
    adapter: Ecto.Adapters.Postgres
end
