class CloudInitTemplateHelper
  pattr_initialize :remote_ip

  def config(name)
    name = name.to_s.upcase

    if Rails.env.test? || Rails.env.development?
      "test-config-#{name}"
    else
      ENV["CLOUD_INIT_CONFIG_#{name}"] || raise("Missing ENV: CLOUD_INIT_CONFIG_#{name}")
    end
  end

  def username
    config(:username)
  end

  def password
    password_salt =
      if Rails.env.test? || Rails.env.development?
        "test-salt"
      else
        ENV.fetch("CLOUD_INIT_PASSWORD_SALT")
      end

    combined = "#{password_salt}:#{remote_ip}"
    hash = Digest::SHA256.hexdigest(combined)
    hash.first(32)
  end
end
