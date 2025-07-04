require "test_helper"

class GameEventTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    @valid_attributes = {
      game_name: "Test Game",
      occurred_at: Time.current,
      event_type: "COMPLETED",
      user: @user
    }
  end

  test "should be valid with all attributes" do
    game_event = GameEvent.new(@valid_attributes)
    assert game_event.valid?
  end

  test "should be invalid without game_name" do
    game_event = GameEvent.new(@valid_attributes.except(:game_name))
    assert_not game_event.valid?
    assert_includes game_event.errors[:game_name], "can't be blank"
  end

  test "should be invalid without occurred_at" do
    game_event = GameEvent.new(@valid_attributes.except(:occurred_at))
    assert_not game_event.valid?
    assert_includes game_event.errors[:occurred_at], "can't be blank"
  end

  test "should be invalid without event_type" do
    game_event = GameEvent.new(@valid_attributes.except(:event_type))
    assert_not game_event.valid?
    assert_includes game_event.errors[:event_type], "can't be blank"
  end

  test "should be invalid without user" do
    game_event = GameEvent.new(@valid_attributes.except(:user))
    assert_not game_event.valid?
    assert_includes game_event.errors[:user], "must exist"
  end
end
