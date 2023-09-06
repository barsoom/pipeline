RAILS_ROOT = File.expand_path("..", __dir__)
$: << File.join(RAILS_ROOT, "app/models")
$: << File.join(RAILS_ROOT, "app/presenters")
$: << File.join(RAILS_ROOT, "lib")
$: << File.join(RAILS_ROOT, "unit")
$: << RAILS_ROOT

Dir[File.join(RAILS_ROOT, "unit/support/*.rb")].each { |f| require f }
Dir[File.join(RAILS_ROOT, "spec/support/shared/*.rb")].each { |f| require f }
Dir[File.join(RAILS_ROOT, "spec/support/shared_examples/*.rb")].each { |f| require f }

require "attr_extras"

RSpec.configure(&:disable_monkey_patching!)
