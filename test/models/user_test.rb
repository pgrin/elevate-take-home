require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should be invalid without email" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should be invalid without password" do
    @user.password = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "should have many game_events" do
    assert_respond_to @user, :game_events
  end

  test "should encrypt password" do
    @user.save!
    assert_not_equal "password123", @user.encrypted_password
    assert @user.valid_password?("password123")
  end
end
