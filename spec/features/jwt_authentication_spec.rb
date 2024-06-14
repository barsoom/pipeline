require "spec_helper"

RSpec.describe "JWT authenticate", type: :feature do
  let(:secret_key) { "test" * 20 }
  let(:invalid_secret_key) { secret_key + "." }

  before do
    ENV["JWT_SESSION_TIMEOUT_IN_SECONDS"] = "600"
    ENV["JWT_KEY"] = secret_key
    ENV["JWT_AUTH_MISSING_REDIRECT_URL"] = "http://auth.example.com/request_jwt_auth?app=pipeline"
    ENV["JWT_ALGORITHM"] = "HS512"

    ENV["WEB_PASSWORD"] = "test"
  end

  after do
    ENV["JWT_SESSION_TIMEOUT_IN_SECONDS"] = nil
    ENV["JWT_KEY"] = nil
    ENV["JWT_AUTH_MISSING_REDIRECT_URL"] = nil
    ENV["JWT_ALGORITHM"] = nil

    ENV["WEB_PASSWORD"] = nil
  end

  it "can authenticate with JWT" do
    # Shows you pipeline at the correct URL when authenticated
    token = build_token(secret: secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Pipeline")
    expect(current_url).to eq("http://www.example.com/")
  end

  it "does not provide access without a valid token" do
    token = build_token(secret: invalid_secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(403)
  end

  it "does not authenticate with JWT when there it is not configured" do
    ENV["JWT_KEY"] = nil

    token = build_token(secret: invalid_secret_key)
    visit "/?jwt_authentication_token=#{token}"
    expect(page.status_code).to eq(401)

    # falls back to web password
    visit "/?jwt_authentication_token=#{token}&pw=test"
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Pipeline")
  end

  private

  def build_token(secret:)
    payload_data = { exp: Time.now.to_i + 2, user: {} }
    JWT.encode(payload_data, secret, "HS512")
  end
end
