# NOTE: Also check config/cable.yml since it connects to redis independently of this.

$redis =
  if ENV["USING_SENTINEL_URL"]
    sentinel_uri = URI.parse(ENV["SENTINEL_URL"])
    redis_uri = URI.parse(ENV["REDIS_URL"])
    name = sentinel_uri.path.delete_prefix("/")
    sentinels = Resolv.getaddresses(sentinel_uri.host).map { { host: it, port: sentinel_uri.port } }
    sentinel_username = sentinel_uri.user
    sentinel_password = sentinel_uri.password
    username = redis_uri.user
    password = redis_uri.password
    Redis.new(url: nil, name:, sentinels:, sentinel_username:, sentinel_password:, username:, password:)
  else
    port = ENV["DEVBOX"] ? `service_port redis`.strip : 6379
    uri = URI.parse(ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"] || "redis://localhost:#{port}")
    Redis.new(host: uri.host, port: uri.port, password: uri.password, db: Rails.env.test? ? 1 : 0)
  end
