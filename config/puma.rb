workers Integer(ENV["WEB_CONCURRENCY"] || 2)
threads_count = Integer(ENV["RAILS_MAX_THREADS"] || 5)
threads threads_count

raise_exception_on_sigterm false # On receiving SIGTERM, just exit gracefully.

preload_app!

port        ENV["PORT"]     || 3000
environment ENV["RACK_ENV"] || "development"
