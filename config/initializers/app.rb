class App
  def self.api_token
    if Rails.env.test? || Rails.env.development?
      "test-api-token"
    else
      ENV["API_TOKEN"] || raise("Missing API_TOKEN")
    end
  end

  def self.github_pat_token
    if Rails.env.test? || Rails.env.development?
      "test-github-pat-token"
    else
      ENV["GITHUB_PAT_TOKEN"] || raise("Missing GITHUB_PAT_TOKEN")
    end
  end

  def self.revisions_to_keep
    (ENV["REVISIONS_TO_KEEP"] || 500).to_i
  end
end
