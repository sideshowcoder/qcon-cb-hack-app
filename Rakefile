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

desc "create the needed configuration files"
task :configure => :dotenv do
  config_path = "#{$APP_ROOT}/config/sync_gateway_config.json"
  puts "writing sync_gateway config to #{config_path}..."
  File.open(config_path, "w") do |f|
    template = ERB.new(File.read("#{config_path}.erb"))
    f.write template.result(binding)
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
end
