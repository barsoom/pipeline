DUMP_PATH = "/tmp/pipeline_prod_db.dump"

namespace :app do
  desc "Reset development database from a production dump"
  task reset: [ :dump_db, :download_db, :import_db, :"db:migrate", :"db:test:prepare" ] do
    puts "Done!"
  end

  desc "Dump the production DB"
  task :dump_db do
    system("heroku pg:backups capture --app ci-pipeline") || exit(1)
  end

  # https://devcenter.heroku.com/articles/heroku-postgres-import-export
  desc "Download the production dump"
  task :download_db do
    system("curl", "--output", DUMP_PATH, `heroku pg:backups public-url --app ci-pipeline`.chomp) || exit(1)
  end

  desc "Import the downloaded dump"
  task import_db: [ :"db:drop", :"db:create" ] do
    if ENV["DEVBOX"]
      system(%{PGPASSWORD=dev pg_restore --no-acl --no-owner -d pipeline_development --username postgres --host localhost --port $(service_port postgres) "#{DUMP_PATH}"}) || exit(1)
    else
      system(%{pg_restore --no-acl --no-owner -d pipeline_development "#{DUMP_PATH}"}) || exit(1)
    end
  end

  desc "Show the username and password for a cloud-init server"
  task :cloud_init_login, [:remote_ip] => :environment do |_t, args|
    remote_ip = args[:remote_ip]
    helper = CloudInitTemplateHelper.new(remote_ip)
    puts "Cloud init server #{remote_ip} has username \"#{helper.username}\" and password \"#{helper.password}\" (if the template uses them)"
  end

end
