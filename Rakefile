desc "start the dev server"
task :server do
  system "bundle exec shotgun --server=thin --port=3000 config.ru"
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

