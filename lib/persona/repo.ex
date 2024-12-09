defmodule Persona.Repo do
  use Ecto.Repo,
    otp_app: :persona,
    adapter: Ecto.Adapters.Postgres
end
