require "test_helper"

class TestCredentialsTest < ActionDispatch::IntegrationTest
  test "credentials are loaded from unencrypted test file" do
    assert_equal "foobar", Rails.application.credentials.secret_key_base
  end
end
