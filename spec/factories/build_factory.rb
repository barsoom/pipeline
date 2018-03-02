FactoryBot.define do
  factory :build do
    name "pipeline_tests"
    revision { FactoryBot.build(:revision) }
    status "building"
  end
end
