require "erb"
require "dotenv"
Dotenv.load

worker_processes 3
timeout 30
preload_app true

def platform
  if (/darwin/ =~ RUBY_PLATFORM) != nil
    "osx"
  else
    "ubuntu"
  end
end

def sync_gateway_config
  config_path = "config/sync_gateway_config.json"
  File.open(config_path, "w") do |f|
    template = ERB.new(File.read("#{config_path}.erb"))
    f.write template.result(binding)
  end
  config_path
end

# start sync gateway
before_fork do |server, worker|
  @sync_gateway_pid ||= spawn("bin/sync_gateway_#{platform}", sync_gateway_config)
end
