defmodule OpApi.Repo do
  use Ecto.Repo,
    otp_app: :op_api,
    adapter: Ecto.Adapters.Postgres
end
