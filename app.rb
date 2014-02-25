require "sinatra"
require 'sinatra/twitter-bootstrap'

class App < Sinatra::Base

  configure do
    set :session_secret, ENV["SESSION_SECRET"]
    set :root, File.dirname(__FILE__)
    enable :sessions
  end

  register Sinatra::Twitter::Bootstrap::Assets

  get "/" do
    erb :index, locals: { value: "foo" }
  end

end
