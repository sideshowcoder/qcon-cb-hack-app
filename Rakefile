require "rake/testtask"
require "erb"
require "dotenv/tasks"

$APP_ROOT = File.dirname(__FILE__)

desc "start the dev server"
task :server do
  system "bundle exec shotgun --port=3000 config.ru"
end

desc "open IRB with app loaded"
task :console do
  $LOAD_PATH.unshift File.join($APP_ROOT, "lib")
  $LOAD_PATH.unshift File.join($APP_ROOT)

  require "irb"
  require "irb/completion"
  require "app"
  ARGV.clear
  IRB.start
end

namespace :configure do
  desc "create the needed configuration files for sync_gateway"
  task :sync_gateway => :dotenv do
    sync_gateway_config_path = "#{$APP_ROOT}/config/sync_gateway_config.json"
    puts "writing sync_gateway config to #{sync_gateway_config_path}..."
    File.open(sync_gateway_config_path, "w") do |f|
      template = ERB.new(File.read("#{sync_gateway_config_path}.erb"))
      f.write template.result(binding)
    end
  end

  desc "copy nginx configuration files in place"
  task :nginx do
    puts "moving nginx config in place..."
    system "sudo cp #{$APP_ROOT}/config/nginx.conf /etc/nginx/nginx.conf"
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
end
