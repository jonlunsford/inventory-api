defmodule Inventory.Api.V1.SessionControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  test "GET /api/v1/session" do
    conn = get build_conn, "/api/v1/session"
    status = json_response(conn, 200)["status"]
    assert status == "OK"
  end
end
