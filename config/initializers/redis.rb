port = ENV["DEVBOX"] ? `service_port redis`.strip : 6379
uri = URI.parse(ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"] || "redis://localhost:#{port}")
$redis = Redis.new(host: uri.host, port: uri.port, password: uri.password, db: Rails.env.test? ? 1 : 0)
