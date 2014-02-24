$APP_ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift File.join($APP_ROOT, "lib")

require "dotenv"
Dotenv.load

require "bundler/setup"
require "app"

run App
