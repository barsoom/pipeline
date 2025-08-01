Rails.application.config.to_prepare do
  Honeybadger.configure do |config|
    config.insights.enabled = false
  end
end
