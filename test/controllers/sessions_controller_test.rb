require "test_helper"

class Api::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should login successfully and return JWT token" do
    post "/api/sessions", params: { email: @user.email, password: "password123" }

    assert_response :success
    response_body = JSON.parse(response.body)
    assert response_body["token"], "Expected response to include a token"
  end

  test "should not login with incorrect password" do
    post "/api/sessions", params: { email: @user.email, password: "wrongpassword" }

    assert_response :unauthorized
    response_body = JSON.parse(response.body)
    assert_equal "Invalid email or password.", response_body["error"]
  end

  test "should not login with non-existing user" do
    post "/api/sessions", params: { email: "nonexistent@example.com", password: "password123" }

    assert_response :unauthorized
    response_body = JSON.parse(response.body)
    assert_equal "Invalid email or password.", response_body["error"]
  end
end
