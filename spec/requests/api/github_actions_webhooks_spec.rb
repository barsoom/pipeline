require "spec_helper"

RSpec.describe "POST /api/github_actions_webhook", type: :request do
  let(:attributes) {
    {
      repository: { ssh_url: "git@example.com:user/foo.git" },
      workflow_job: {
        name: "foo_tests",
        head_sha: "440f78f6de0c71e073707d9435db89f8e5390a59",
        status: "success",
        html_url: "http://example.com/status-for-job/foo_tests"
      }
    }
  }

  it "adds or updates build status" do
    allow(App).to receive(:api_token).and_return("secret")
    post "/api/github_actions_webhook", params: attributes.merge(token: "secret")
    expect(response).to be_successful
    expect(Build.last.status).to eq("successful")
  end

  it "fails when the api token is wrong" do
    post "/api/github_actions_webhook", params: attributes.merge(token: "secret")
    expect(response.code).to eq("401")
    expect(Build.all).to be_empty
  end
end
