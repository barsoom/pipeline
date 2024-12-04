require "spec_helper"

RSpec.describe "GET /api/cloud_init", type: :request do
  it "gets a cloud-init config if you have the right api token" do
    cloud_init = CloudInit.create!(name: "foo", data: "#cloud-config...")
    allow(App).to receive(:api_token).and_return("secret")

    get "/api/cloud_init?token=secret&name=foo"

    expect(response).to be_successful
    expect(response.body).to include("#cloud-config")
  end

  it "fails when the api token is wrong" do
    cloud_init = CloudInit.create!(name: "foo", data: "#cloud-config...")
    allow(App).to receive(:api_token).and_return("secret")

    get "/api/cloud_init?token=wrong&name=foo"

    expect(response).not_to be_successful
    expect(response.body).not_to include("#cloud-config")
  end

  it "fails when the name is unknown" do
    cloud_init = CloudInit.create!(name: "foo", data: "#cloud-config...")
    allow(App).to receive(:api_token).and_return("secret")

    get "/api/cloud_init?token=wrong&name=bar"

    expect(response).not_to be_successful
    expect(response.body).not_to include("#cloud-config")
  end
end
