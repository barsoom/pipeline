require "spec_helper"

RSpec.describe "DELETE /api/projects", type: :request do
  it "removes a project" do
    project1 = FactoryBot.create(:project, name: "foo")
    project2 = FactoryBot.create(:project, name: "bar")

    allow(App).to receive(:api_token).and_return("secret")

    delete "/api/projects/foo", params: { token: "secret" }

    expect(response).to be_successful
    expect(Project.find_by_id(project1.id)).to be_nil
    expect(Project.find_by_id(project2.id)).not_to be_nil

    # denies access with an invalid token
    delete "/api/projects/foo", params: { token: "invalid-secret" }

    expect(response).not_to be_successful
    expect(Project.find_by_id(project2.id)).not_to be_nil
  end
end
