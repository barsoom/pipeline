require "spec_helper"

RSpec.describe Revision do
  it "requires a valid revision" do
    revision = FactoryBot.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a59")
    expect(revision).to be_valid

    revision = FactoryBot.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a5")
    expect(revision).not_to be_valid

    revision = FactoryBot.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390A59")
    expect(revision).not_to be_valid

    revision = FactoryBot.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a5 ")
    expect(revision).not_to be_valid
  end
end

RSpec.describe Revision, "#github_url" do
  it "is a url to the revision on github" do
    project = Project.new(repository: "git@github.com:barsoom/pipeline.git")
    revision = Revision.new(name: "7220d9a3bdd24de48435406016177be7165b1cc2")
    revision.project = project
    expect(revision.github_url).to eq("https://github.com/barsoom/pipeline/commit/7220d9a3bdd24de48435406016177be7165b1cc2")
  end

  it "is nil when there are no such url" do
    revision = Revision.new
    revision.project = Project.new
    expect(revision.github_url).to be_nil
  end
end

RSpec.describe Revision, "#newer_revisions" do
  it "returns any newer revisions in the same project" do
    project = FactoryBot.create(:project)
    revision1 = FactoryBot.create(:revision, project:, name: "1111111111111111111111111111111111111111")
    revision2 = FactoryBot.create(:revision, project:, name: "2222222222222222222222222222222222222222")

    expect(revision1.newer_revisions).to eq([ revision2 ])
    expect(revision2.newer_revisions).to eq([])
  end
end

RSpec.describe Revision, "#seconds_from_creation_to_last_build_update" do
  it "is the number of seconds from creation to the last build update" do
    revision = Revision.new(created_at: 10.minutes.ago)
    revision.builds = [
      Build.new(updated_at: 2.minutes.ago),
      Build.new(updated_at: 5.minutes.ago),
    ]

    expect(revision.seconds_from_creation_to_last_build_update).to be_within(1.second).of(8.minutes)
  end
end
