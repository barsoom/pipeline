require "httparty"

# NOTE: This class only tested manually (don't expect it to change much and outgoing http calls and threads are tricky to test)

class PostStatusToWebhook
  method_object :project

  TIMEOUT = 10 # seconds

  def call
    return unless webhook_urls

    # Build payload outside of thread so that we don't leak active record connections,
    # or some other such thing.
    payload = build_payload

    webhook_urls.split.each do |webhook_url|
      Thread.new do
        HTTParty.post(webhook_url, body: { payload: }, timeout: TIMEOUT)
      end
    end
  end

  private

  def build_payload
    ProjectStatusSerializer.new(project).serialize.to_json
  end

  def webhook_urls
    ENV.fetch("WEBHOOK_URLS", nil)
  end
end
