require "spec_helper"
require "build_status"
require "merge_builds"

RSpec.describe MergeBuilds do
  before do
    stub_const "Build", Struct.new(:name, :status)
  end

  it "merges 'building' and anything to 'building'" do
    builds = [
      Build.new(name: "tests_0", status: "building"),
      Build.new(name: "tests_1", status: "failed"),
    ]

    build = MergeBuilds.call(builds)

    expect(build.name).to eq("tests_0_and_tests_1")
    expect(build.status).to eq("building")
  end

  it "merges 'pending' and anything to 'pending'" do
    builds = [
      Build.new(name: "tests_0", status: "successful"),
      Build.new(name: "tests_1", status: "pending"),
    ]

    build = MergeBuilds.call(builds)

    expect(build.name).to eq("tests_0_and_tests_1")
    expect(build.status).to eq("pending")
  end

  it "merges 'fixed' and anything to 'fixed'" do
    builds = [
      Build.new(name: "tests_0", status: "successful"),
      Build.new(name: "tests_1", status: "fixed"),
    ]

    build = MergeBuilds.call(builds)

    expect(build.name).to eq("tests_0_and_tests_1")
    expect(build.status).to eq("fixed")
  end

  it "merges 'failed' and 'successful' to 'failed'" do
    builds = [
      Build.new(name: "tests_0", status: "successful"),
      Build.new(name: "tests_1", status: "failed"),
    ]

    build = MergeBuilds.call(builds)

    expect(build.name).to eq("tests_0_and_tests_1")
    expect(build.status).to eq("failed")
  end

  it "merges the same status to itself" do
    builds = [
      Build.new(name: "tests_0", status: "successful"),
      Build.new(name: "tests_1", status: "successful"),
    ]

    build = MergeBuilds.call(builds)

    expect(build.name).to eq("tests_0_and_tests_1")
    expect(build.status).to eq("successful")
  end
end
