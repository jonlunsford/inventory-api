defmodule Inventory.ApplicationController do
  defmacro __using__(_) do
    quote do
      def action(conn, _), do: Inventory.ApplicationController.__action__(__MODULE__, conn)
      defoverridable action: 2
    end
  end

  def __action__(controller,conn) do
    args = [conn, conn.params, Guardian.Plug.current_resource(conn) || :guest ]
    apply(controller, Phoenix.Controller.action_name(conn), args)
  end
end
