defmodule OpApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      OpApi.Repo,
      # Start the endpoint when the application starts
      OpApiWeb.Endpoint,
      # Start additional processes
      OpApi.Scraper,
      {Operate, [
        tape_adapter: {Operate.Adapter.Terminus, [
          token: Application.get_env(:op_api, :planaria_token)
        ]},
        proc_adapter: OpApi.Operate.EctoAdapter,
        cache: Operate.Cache.ConCache,
        aliases: %{
          "meta" => "ec869026",
          "15PciHG22SNLQJXMoSUaWVi7WSqc7hCfva" => "a3a83843", # AIP
          "19HxigV4QyBv3tHpQVcUEQyq1pzZVdoAut" => "6232de04", # B://
          "13SrNDkVzY5bHBRKNu5iXTQ7K7VqTh5tJC" => "a575f641", # Bitkey
          "1L8eNuA8ToLGK5aV4d5d9rXUAbRZUxKrhF" => "c8bca1c8", # Bit.sv
          "1HA1P2exomAwCUycZHr8WeyFoy5vuQASE3" => "ed469ce8", # HAIP
          "1PuQa7K62MiKCtssSLKy1kh56WWU7MtUR5" => "b7f56e90", # MAP
          "19dbzMDDg4jZ4pvYzLb291nT8uCqDa61zH" => "5ad609a8", # Preev
          "1LtyME6b5AnMopQrBPLk4FGN8UBuhxKqrn" => "5ad609a8", # WeatherSV
          "c7e30124267ad8b1cc0f3fe8da6cd8513a9a82f32d11c6f25b40e2b48e39b7f0" => "1812437c" # object/put
        }
      ]},
      {ConCache, [
        name: :operate,
        ttl_check_interval: :timer.minutes(1),
        global_ttl: :timer.minutes(60),
        touch_on_read: true
      ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OpApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OpApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
