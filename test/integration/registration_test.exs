defmodule Inventory.RegistrationIntegrationTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session(driver: %{chromeOptions: %{"args" => [
    "--user-agent=#{Hound.Browser.user_agent(:chrome)}",
    "--headless",
    "--disable-gpu"
  ]}})

  test "the truth" do
    navigate_to("/")
    element = find_element(:name, "email")
    fill_field(element, "test@test.com")
    submit_element(element)

    assert page_title() == "Thank you"
  end
end
