require 'test_helper'

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    @token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first
  end

  test "should create a new user" do
    post '/api/user', params: { email: 'newuser@example.com', password: 'password' }

    assert_response :created
    assert User.find_by(email: 'newuser@example.com')
  end

  test "should not allow duplicate user" do
    post '/api/user', params: { email: @user.email, password: 'password' }

    assert_response :unprocessable_entity
    assert_match /User already exists/, @response.body
  end

  test "should show user stats with authentication" do
    SubscriptionService.stub :get_subscription_status, "active" do
      get '/api/user', headers: { 'Authorization' => "Bearer #{@token}" }

      assert_response :success
      body = JSON.parse(@response.body)

      assert_equal @user.email, body['user']['email']
      assert_equal 0, body['user']['stats']['total_games_played']
      assert_equal "active", body["user"]["stats"]["subscription_status"]
    end
  end

  test "should reject unauthenticated user show request" do
    get '/api/user'
    assert_response :unauthorized
  end
end
