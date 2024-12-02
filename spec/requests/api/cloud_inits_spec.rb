require "spec_helper"

RSpec.describe "GET /api/cloud_init", type: :request do
  it "gets a cloud init config if you have the right api token" do
    allow(App).to receive(:api_token).and_return("secret")

    get "/api/cloud_init?token=secret"

    expect(response).to be_successful
    expect(response.body).to include("#cloud-config")
  end

  it "fails when the api token is wrong" do
    allow(App).to receive(:api_token).and_return("secret")

    get "/api/cloud_init?token=wrong"

    expect(response).not_to be_successful
    expect(response.body).not_to include("#cloud-config")
  end
end
