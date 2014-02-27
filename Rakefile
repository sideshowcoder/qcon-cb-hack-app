require "rake/testtask"

desc "start the dev server"
task :server do
  system "bundle exec shotgun --port=3000 config.ru"
end

desc "open IRB with app loaded"
task :console do
  $APP_ROOT = File.dirname(__FILE__)
  $LOAD_PATH.unshift File.join($APP_ROOT, "lib")
  $LOAD_PATH.unshift File.join($APP_ROOT)

  require "irb"
  require "irb/completion"
  require "app"
  ARGV.clear
  IRB.start
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
end
