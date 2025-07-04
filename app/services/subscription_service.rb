class SubscriptionService
  CACHE_EXPIRY = 1.hour
  CACHE_KEY_PREFIX = "subscription_status/"

  def self.connection
    @connection ||= Faraday.new(url: 'https://interviews-accounts.elevateapp.com') do |f|
      f.request :url_encoded

      # retry the request up to 3 times if the request fails
      f.request :retry,
                max: 3,
                interval: 0.5,
                backoff_factor: 2,
                exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::RetriableResponse],
                methods: [:get, :post, :put, :delete],
                retry_statuses: (500..599).to_a

      f.adapter Faraday.default_adapter
    end
  end

  def self.get_subscription_status(user)
    cache_key = "#{CACHE_KEY_PREFIX}#{user.id}"
    result = Rails.cache.read(cache_key)
    Rails.logger.debug "Result from cache: #{result}"

    # cache the results
    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
      Rails.logger.info "Getting subscription status for user: #{user.inspect}"
      begin
        response = connection.get("api/v1/users/#{user.id}/billing") do |req|
          req.headers['Authorization'] = "Bearer #{Rails.application.credentials.subscription_service[:jwt_token]}"
          req.headers['Content-Type'] = 'application/json'
        end

        if response.success?
          data = JSON.parse(response.body)
          data["subscription_status"]
        else
          Rails.logger.error("API Error: #{response.status} - #{response.body}")
          nil
        end
      rescue Faraday::Error => e
        Rails.logger.error("API Request Failed: #{e.message}")
        nil
      end
    end
  end
end