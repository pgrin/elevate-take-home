require "test_helper"

class Api::GameEventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    @token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first
    @headers = { 'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json' }
  end

  test "should create game event with valid params" do
    payload = {
      game_event: {
        game_name: "Brevity",
        type: "COMPLETED",
        occurred_at: "2025-01-01T00:00:00.000Z"
      }
    }

    post '/api/user/game_events', params: payload.to_json, headers: @headers

    assert_response :created
  end

  test "should return error if required fields are missing" do
    payload = { game_event: { game_name: "", type: "", occurred_at: "" } }

    post '/api/user/game_events', params: payload.to_json, headers: @headers

    assert_response :unprocessable_entity
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Missing required fields"
  end

  test "should return error if type is not COMPLETED" do
    payload = {
      game_event: {
        game_name: "Brevity",
        type: "STARTED",
        occurred_at: "2025-01-01T00:00:00.000Z"
      }
    }

    post '/api/user/game_events', params: payload.to_json, headers: @headers

    assert_response :unprocessable_entity
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Invalid type"
  end

  test "should return unauthorized without token" do
    payload = {
      game_event: {
        game_name: "Brevity",
        type: "COMPLETED",
        occurred_at: "2025-01-01T00:00:00.000Z"
      }
    }

    post '/api/user/game_events', params: payload.to_json

    assert_response :unauthorized
  end
end
