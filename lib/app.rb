require "sinatra"

class App < Sinatra::Base
  configure do
    set :session_secret, ENV["SESSION_SECRET"]
    enable :sessions
  end

  get "/" do
    "Hello world"
  end
end
