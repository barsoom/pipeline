class CloudInitTemplateHelper
  pattr_initialize [ :cloud_init!, :remote_ip! ]

  def config(name)
    cloud_init.config.fetch(name)
  end

  def password
    secret =
      if Rails.env.test? || Rails.env.development?
        "test-secret"
      else
        ENV.fetch("CLOUD_INIT_PASSWORD_SECRET")
      end

    combined = "#{secret}:#{cloud_init.password_salt}:#{remote_ip}"
    hash = Digest::SHA256.hexdigest(combined)
    hash.first(32)
  end
end
