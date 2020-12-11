# FIXME: Remove this file when https://github.com/rails/rails/issues/40795 has a fix.

Rake::Task[ "yarn:install" ].clear
namespace :yarn do
  desc "Disabling internal yarn install from Rails"
  task install: :environment do
    puts "Disabling internal yarn install from Rails"
  end
end

Rake::Task[ "webpacker:yarn_install" ].clear
namespace :webpacker do
  desc "Disabling internal yarn install from Rails"
  task yarn_install: :environment do
    puts "Disabling internal yarn install from Rails"
  end
end
