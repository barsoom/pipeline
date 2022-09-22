require "spec_helper"

RSpec.describe Build do
  it "requires a name" do
    build = FactoryBot.build(:build, name: nil)
    expect(build).not_to be_valid
  end

  it "requires a status" do
    build = FactoryBot.build(:build, status: nil)
    expect(build).not_to be_valid
  end
end
