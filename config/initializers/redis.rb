# NOTE: Also check config/cable.yml since it connects to redis independently of this.

$redis =
  if ENV["USING_SENTINEL_URL"]
    uri = URI.parse(ENV["SENTINEL_URL"])
    name = uri.path.delete_prefix("/")
    sentinels = Resolv.getaddresses(uri.host).map { { host: it, port: uri.port } }
    sentinel_username = uri.user
    sentinel_password = uri.password
    Redis.new(name:, sentinels:, sentinel_username:, sentinel_password:)
  else
    port = ENV["DEVBOX"] ? `service_port redis`.strip : 6379
    uri = URI.parse(ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"] || "redis://localhost:#{port}")
    Redis.new(host: uri.host, port: uri.port, password: uri.password, db: Rails.env.test? ? 1 : 0)
  end
