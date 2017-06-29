defmodule Inventory.RegistrationControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase, async: true

  describe "new/2" do
    test "Renders the new template", %{conn: conn} do
      conn = get conn, :registration
      assert html_response(conn, 200)
    end
  end
end
