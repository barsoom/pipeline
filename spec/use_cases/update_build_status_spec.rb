require "spec_helper"

describe UpdateBuildStatus do
  let(:update_build_status) { described_class }

  def update_with(custom = {})
    build_attributes = {
      name: "foo_tests",
      repository: "git@example.com:user/foo.git",
      revision: "440f78f6de0c71e073707d9435db89f8e5390a59",
      status_url: "http://example.com/builds/1",
      status: "building",
    }.merge(custom)

    update_build_status.run(build_attributes)
  end

  context "when there are no previous builds" do
    it "adds a build, a revision and a project" do
      update_with name: "deployer_tests", repository: "git@example.com:user/bar.git"

      builds = Build.all
      builds.size.should == 1
      build = builds.first
      expect(build.name).to eq("deployer_tests")
      expect(build.status_url).to eq("http://example.com/builds/1")
      expect(build.revision.project.name).to eq("bar")
    end
  end

  context "when there are previous builds" do
    it "updates the status" do
      update_with status: "building"
      update_with status: "successful", status_url: "http://example.com/updated"

      builds = Build.all
      builds.size.should == 1
      builds.first.status.should == "successful"
      builds.first.status_url.should == "http://example.com/updated"
    end
  end

  context "when builds for a new revision is posted" do
    it "adds another revision" do
      update_with revision: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      update_with revision: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

      expect(Revision.count).to eq(2)
    end
  end

  context "when there are more than App.builds_to_keep builds" do
    it "removes the oldest build" do
      App.stub(revisions_to_keep: 2)
      update_with revision: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      update_with revision: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
      update_with revision: "cccccccccccccccccccccccccccccccccccccccc"

      project = Project.last
      list = project.revisions.map(&:name).to_s
      list.should_not include("a")
      list.should include("b")
      list.should include("c")

      expect(Build.count).to eq(2)
    end
  end
end