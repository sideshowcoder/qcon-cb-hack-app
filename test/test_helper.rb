$APP_ROOT = File.join(File.dirname(__FILE__), "..")
$LOAD_PATH.unshift File.join($APP_ROOT)
$LOAD_PATH.unshift File.join($APP_ROOT, "lib")

require "dotenv"
Dotenv.load

ENV["RACK_ENV"] = "test"
require "minitest/autorun"
