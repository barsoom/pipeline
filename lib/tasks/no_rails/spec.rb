task :spec do
  system("rspec", *Dir["spec/**/*_spec.rb"]) || exit(1)
end

namespace :spec do
  task :unit do
    spec_helper_path = File.expand_path("unit/spec_helper.rb")
    system("rspec", "-r#{spec_helper_path}", *Dir["unit/**/*_spec.rb"]) || exit(1)
    puts
  end
end

task default: [ :"spec:unit", :"spec" ]
