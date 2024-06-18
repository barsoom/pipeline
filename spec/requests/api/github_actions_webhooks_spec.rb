require "spec_helper"

RSpec.describe "POST /api/github_actions_webhook", type: :request do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GITHUB_WEBHOOK_SECRET").and_return("secret")
    allow(Rack::Utils).to receive(:secure_compare).with(start_with("sha256="), "sha256=secret").and_return(true)
  end

  let(:attributes) {
    {
      repository: { ssh_url: "git@example.com:user/foo.git" },
      workflow_job: {
        name: "foo_tests",
        head_sha: "440f78f6de0c71e073707d9435db89f8e5390a59",
        status: "success",
        html_url: "http://example.com/status-for-job/foo_tests",
      },
    }
  }

  it "adds or updates build status" do
    post "/api/github_actions_webhook", headers: { "X-Hub-Signature-256" => "sha256=secret" }, params: attributes

    expect(response).to be_successful
    expect(Build.last.status).to eq("successful")
  end

  it "ignores requests without a workflow job" do
    post "/api/github_actions_webhook", headers: { "X-Hub-Signature-256" => "sha256=secret" }, params: { zen: "something else" }

    expect(response).to be_successful
    expect(Build.all).to be_empty
  end

  it "fails when the api token is wrong" do
    allow(Rack::Utils).to receive(:secure_compare).with(start_with("sha256="), "sha256=wrong-secret").and_return(false)

    post "/api/github_actions_webhook", headers: { "X-Hub-Signature-256" => "sha256=wrong-secret" }, params: attributes

    expect(response.code).to eq("401")
    expect(Build.all).to be_empty
  end
end
