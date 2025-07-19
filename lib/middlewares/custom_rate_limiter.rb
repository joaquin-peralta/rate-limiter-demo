require "redis"

module Middlewares
  MAX_PER_WINDOW = 5
  WINDOW_SIZE = 20

  class CustomRateLimiter
    def initialize(app)
      @app = app
      @redis = Redis.new(host: ENV.fetch("REDIS_HOST", "redis"), port: 6379)
    end

    def call(env)
      request = Rack::Request.new(env)
      identifier = request.ip
      key = "rate_limit:#{identifier}"

      current = @redis.get(key).to_i

      if current >= MAX_PER_WINDOW
        return rate_limited_response
      else
        increment_request_count(key, WINDOW_SIZE)
        return @app.call(env)
      end
    end

    private

    def increment_request_count(key, window)
      if @redis.exists?(key)
        @redis.incr(key)
      else
        @redis.set(key, 1, ex: window)
      end
    end

    def rate_limited_response
      body = { error: "Rate limit exceeded" }.to_json
      [429, { "Content-Type" => "application/json" }, [body]]
    end
   
  end
end