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
    erb :index, locals: { token: nil }
  end

  post "/signup" do
    # TODO connect to couchbase
    # TODO store token in session
    # TODO create the user in couchbase, or return the already created token
    # TODO create the user in the sync gateway username is email password is the token
    # TODO present the token to the user
    # TODO present the user with the JSON documents he should store under his user
  end
end
