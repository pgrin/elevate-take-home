require "test_helper"

class SubscriptionServiceTest < ActiveSupport::TestCase
  def setup
    @user = User.new(id: 123)
    @cache_key = "subscription_status/#{@user.id}"
    Rails.cache.delete(@cache_key)
  end

  test "caches subscription status after first call" do
    response = Minitest::Mock.new
    response.expect :success?, true
    response.expect :body, '{"subscription_status":"active"}'

    connection_mock = Minitest::Mock.new
    connection_mock.expect :get, response, [String]

    SubscriptionService.instance_variable_set(:@connection, nil) # clear the connection

    SubscriptionService.stub :connection, connection_mock do
      status1 = SubscriptionService.get_subscription_status(@user)
      assert_equal "active", status1

      cached_value = Rails.cache.read(@cache_key)
      assert_equal "active", cached_value
    end

    connection_mock.verify
    response.verify

    SubscriptionService.instance_variable_set(:@connection, nil) # clear the connection

    connection_mock2 = Minitest::Mock.new
    SubscriptionService.stub :connection, connection_mock2 do
      status2 = SubscriptionService.get_subscription_status(@user)
      assert_equal "active", status2
    end
  end
end
