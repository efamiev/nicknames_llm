defmodule LifeComplex.Repo do
  use Ecto.Repo,
    otp_app: :life_complex,
    adapter: Ecto.Adapters.Postgres
end
