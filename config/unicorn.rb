require "erb"
require "dotenv"
Dotenv.load

worker_processes 1
timeout 30
preload_app true

app_path = File.join(File.dirname(__FILE__), "..")
pid "#{app_path}/tmp/unicorn.pid"

