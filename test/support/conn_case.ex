defmodule Inventory.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Inventory.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Inventory.Router.Helpers

      # The default endpoint for testing
      @endpoint Inventory.Endpoint

      @default_opts [
        store: :cookie,
        key: "foobar",
        encryption_salt: "encrypted cookie salt",
        signing_salt: "signing salt"
      ]
      @secret String.duplicate("abcdef0123456789", 8)
      @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

      def conn_with_fetched_session(the_conn) do
        put_in(the_conn.secret_key_base, @secret)
        |> Plug.Session.call(@signing_opts)
        |> Plug.Conn.fetch_session
      end

      def sign_in(conn, resource, perms \\ Guardian.Permissions.max) do
        conn
        |> conn_with_fetched_session
        |> Guardian.Plug.sign_in(resource, :token, perms: %{default: perms})
        |> Guardian.Plug.VerifySession.call(%{})
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Inventory.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Inventory.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
