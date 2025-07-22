require "redis"

module Middlewares
  class CustomRateLimiter
    def initialize(app)
      @app = app
      @redis = Redis.new(host: ENV.fetch("REDIS_HOST", "redis"), port: 6379)
    end

    def call(env)
      max_per_window = ENV.fetch("MAX_PER_WINDOW", 0).to_i
      window_size = ENV.fetch("WINDOW_SIZE", 0).to_i

      return @app.call(env) if max_per_window == 0 || window_size == 0

      request = Rack::Request.new(env)

      identifier = request.ip
      key = "rate_limit:#{identifier}"

      current = @redis.get(key).to_i

      increment_request_count(key, window_size) if current <= max_per_window

      # Here there should be a method to limit the response if the value saved in redis
      # is greater than the max_per_window. Something like this:

      # def rate_limited_response
      #   body = { error: "Rate limit exceeded" }.to_json
      #   [429, { "Content-Type" => "application/json" }, [body]]
      # end
   
      #
      # But to show the rate limiter behaviour in a chart I by-passed this part of the middleware and let
      # the request go through anyway after incrementing the request count in redis.

      return @app.call(env)
    end

    private

    def increment_request_count(key, window)
      if @redis.exists?(key)
        @redis.incr(key)
      else
        @redis.set(key, 1, ex: window)
      end
    end
  end
end