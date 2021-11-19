begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)

  RSpec::Core::RakeTask.new("spec:unit") do |t|
    t.rspec_opts = "-r#{File.expand_path("unit/spec_helper.rb")}"
    t.pattern = "unit/**/*_spec.rb"
  end

  task default: %w[ spec:unit spec ]
rescue LoadError
end
