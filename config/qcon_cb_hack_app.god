app_root = File.join(File.dirname(__FILE__), "..")
require "dotenv"
Dotenv.load

# Sync Gateway
God.watch do |w|
  w.name = "sync_gateway"
  w.start = "sync_gateway #{app_root}/config/sync_gateway_config.json"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds

  w.keepalive
end

# Unicorn
God.watch do |w|
  w.name = "unicorn"

  w.start = "cd #{app_root} && \
             bundle exec unicorn \
             -p #{ENV["PORT"]} \
             -E #{ENV["RACK_ENV"]} \
             -c #{app_root}/config/unicorn.rb -D"

  # QUIT gracefully shuts down workers
  w.stop = "kill -QUIT `cat #{app_root}/tmp/unicorn.pid`"

  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{app_root}/tmp/unicorn.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{app_root}/tmp/unicorn.pid"

  w.behavior(:clean_pid_file)
  w.keepalive
end
