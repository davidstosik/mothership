require "application_system_test_case"

class OauthAccountLinkingTest < ApplicationSystemTestCase
  test "account linking flow from logged out state" do
    user = User.create(email: "foo@example.com", password: "foobar")
    user.confirm
    application = Doorkeeper::Application.create(name: "app", redirect_uri: "https://example.org")

    visit oauth_authorization_path(
      state: "foobar",
      client_id: application.uid,
      response_type: "code",
      scope: "",
      redirect_uri: "https://example.org"
    )
    fill_in("Email", with: "foo@example.com")
    fill_in("Password", with: "foobar")
    click_on("Log in")
    click_on("Authorize")

    access_grant = user.reload.access_grants.first
    current_uri = URI.parse(current_url)
    query_parameters = Rack::Utils.parse_nested_query(current_uri.query)
    assert_equal("foobar", query_parameters["state"])
    assert_equal(access_grant.token, query_parameters["code"])
    assert_equal("example.org", current_uri.host)
  end

  test "account linking flow from logged in state" do
    user = User.create(email: "foo@example.com", password: "foobar")
    user.confirm
    application = Doorkeeper::Application.create(name: "app", redirect_uri: "https://example.org")

    visit new_user_session_path
    fill_in("Email", with: "foo@example.com")
    fill_in("Password", with: "foobar")
    click_on("Log in")
    visit oauth_authorization_path(
      state: "foobar",
      client_id: application.uid,
      response_type: "code",
      scope: "",
      redirect_uri: "https://example.org"
    )
    click_on("Authorize")

    access_grant = user.reload.access_grants.first
    current_uri = URI.parse(current_url)
    query_parameters = Rack::Utils.parse_nested_query(current_uri.query)
    assert_equal("foobar", query_parameters["state"])
    assert_equal(access_grant.token, query_parameters["code"])
    assert_equal("example.org", current_uri.host)
  end
end
