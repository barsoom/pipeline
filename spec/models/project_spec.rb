require "spec_helper"

RSpec.describe Project do
  it "is valid" do
    project = FactoryBot.build(:project)
    expect(project).to be_valid
  end

  it "requires a name" do
    project = FactoryBot.build(:project, name: nil)
    expect(project).not_to be_valid
  end
end

RSpec.describe Project do
  it "sets the name from repository" do
    project = Project.new(repository: "git@example.com:user/foo.git")
    expect(project.name).to eq("foo")
  end
end

RSpec.describe Project, "latest_revisions" do
  it "returns the latest revisions in order" do
    project = FactoryBot.create(:project)
    _rev1 = FactoryBot.create(:revision, project:)
    rev2 = FactoryBot.create(:revision, project:)
    rev3 = FactoryBot.create(:revision, project:)
    expect(project.latest_revisions(2).map(&:id)).to eq([ rev3.id, rev2.id ])
  end
end

RSpec.describe Project, "github_url" do
  it "is based on the repository" do
    project = Project.new(repository: "git@github.com:joakimk/pipeline.git")
    expect(project.github_url).to eq("https://github.com/joakimk/pipeline")
  end

  it "is nil when the repository is not on github" do
    expect(Project.new(repository: "git@example.com:foo.git").github_url).to be_nil
    expect(Project.new.github_url).to be_nil
  end
end

RSpec.describe Project, ".all_sorted" do
  it "returns all projects by position, revision age, and alphabetically" do
    a = FactoryBot.create(:project, name: "a", position: 1)
    b = FactoryBot.create(:project, name: "b", position: 1)
    FactoryBot.create(:project, name: "c", position: 1)
    FactoryBot.create(:project, name: "d", position: 0)

    expect(Project.all_sorted.map(&:name)).to eq([ "d", "a", "b", "c" ])

    FactoryBot.create(:revision, project: b, created_at: 1.hour.ago)
    FactoryBot.create(:revision, project: a, created_at: 1.day.ago)

    expect(Project.all_sorted.map(&:name)).to eq([ "d", "b", "a", "c" ]) # no revisions = last
  end
end
