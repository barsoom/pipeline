begin
  require "rspec/core/rake_task"
  desc "Run RSpec tests in spec/"
  RSpec::Core::RakeTask.new(:spec)

  desc "Run RSpec tests in unit/"
  RSpec::Core::RakeTask.new("spec:unit") do |t|
    t.rspec_opts = "-r#{File.expand_path("unit/spec_helper.rb")}"
    t.pattern = "unit/**/*_spec.rb"
  end

  task default: %i[ spec:unit spec ]
rescue LoadError
end
