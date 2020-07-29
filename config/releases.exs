
import Config

# Configure your database
config :op_api, OpApi.Repo,
  username: System.fetch_env!("DB_USER"),
  password: System.fetch_env!("DB_PASSWORD"),
  hostname: System.fetch_env!("DB_HOST"),
  database: "op_api_prod",
  pool_size: 10


# Configure endpoint
config :op_api, OpApiWeb.Endpoint,
  http: [
    port: 4000,
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")


config :op_api,
  app_host: System.fetch_env!("APP_HOST"),
  app_port: System.fetch_env!("APP_PORT"),
  planaria_token: System.fetch_env!("PLANARIA_TOKEN")
