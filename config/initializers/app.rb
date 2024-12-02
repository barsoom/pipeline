class App
  def self.api_token
    if Rails.env.test? || Rails.env.development?
      "test-api-token"
    else
      ENV["API_TOKEN"] || raise("Missing API_TOKEN")
    end
  end

  def self.github_actions_runner_cfg_pat
    if Rails.env.test? || Rails.env.development?
      "test-runner-cfg-pat"
    else
      ENV.fetch("CLOUD_INIT_GITHUB_ACTIONS_RUNNER_CFG_PAT")
    end
  end

  def self.github_actions_runner_scope
    if Rails.env.test? || Rails.env.development?
      "test-runner-scope"
    else
      ENV.fetch("CLOUD_INIT_GITHUB_ACTIONS_RUNNER_SCOPE")
    end
  end

  def self.revisions_to_keep
    (ENV["REVISIONS_TO_KEEP"] || 500).to_i
  end
end
