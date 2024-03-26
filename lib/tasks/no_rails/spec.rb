begin
  require "rspec/core/rake_task"
  desc "Run RSpec tests in spec/"
  RSpec::Core::RakeTask.new(:spec)

  desc "Run RSpec tests in unit/"
  RSpec::Core::RakeTask.new("spec:unit") do |t|
    t.rspec_opts = "-r#{File.expand_path("unit/spec_helper.rb")}"
    t.pattern = "unit/**/*_spec.rb"
  end

  directory "tmp/test-results"

  task default: [ "tmp/test-results", "spec:unit", "spec" ]
rescue LoadError
  task :default do
    puts "No RSpec found, no test tasks defined. This is normal in production."
  end
end
