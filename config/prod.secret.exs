use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :inventory, Inventory.Endpoint,
  secret_key_base: "JXFc5KJBIU3QNw5gs3Esc0iWPww6VfccEdmhPsse4exK9ktpIgDlqhoKPb/viwc6"

# Configure your database
config :inventory, Inventory.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "inventory_prod",
  pool_size: 20
