class PagesController < ApplicationController
  def home
  end

  def trigger
    max_per_window = ENV.fetch('MAX_PER_WINDOW', 0).to_i
    window_size = ENV.fetch('WINDOW_SIZE', 0).to_i

    # Fetch Redis and get the key and value according the user ip

    @redis = Redis.new(host: ENV.fetch("REDIS_HOST", "redis"), port: 6379)

    identifier = request.remote_ip

    key = "rate_limit:#{identifier}"

    value = @redis.get(key).to_i

    puts "VALUE"
    puts value

    status_code = 200
    time = Time.current.to_f

    status_code = 429 if value > max_per_window.to_i

    render json: {
      status_code: status_code,
      time: time
    }
  end

  def options
    if params[:max_per_window].present? && params[:window_size].present?
      ENV["MAX_PER_WINDOW"] = params[:max_per_window]
      ENV["WINDOW_SIZE"] = params[:window_size]

      flash.now[:notice] = "✅ Settings updated successfully."
    else
      flash.now[:alert] = "⚠️ Both values are required."
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: flash.now[:notice] || flash.now[:alert] }
    end
  end
end
