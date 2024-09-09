require "spec_helper"
require "build_status"
require "merge_builds"
require "build_presenter"
require "revision_presenter"
require "build_mapping"

RSpec.describe RevisionPresenter do
  before do
    stub_const "Build", Struct.new(:name, :status, :updated_at)
  end

  describe "#name" do
    it "is the first 5 characters" do
      revision = double(name: "00677457465544877dc2293f724009caa9da03a4")
      presenter = RevisionPresenter.new(revision)
      expect(presenter.name).to eq("00677")
    end
  end

  describe "#builds" do
    it "returns builds" do
      build = Build.new(name: "tests")
      revision = double(builds: [ build ], build_mappings: [])
      presenter = RevisionPresenter.new(revision)
      expect(presenter.builds.map(&:name)).to eq([ "tests" ])
    end
  end
end
