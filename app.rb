require "sinatra"
require "sinatra/twitter-bootstrap"
require "user"

class App < Sinatra::Base

  configure do
    set :session_secret, ENV["SESSION_SECRET"]
    set :root, File.dirname(__FILE__)
    enable :sessions
  end

  register Sinatra::Twitter::Bootstrap::Assets

  get "/" do
    erb :index, locals: locals_with(token: session["user_token"])
  end

  post "/signup" do
    email = params["signup"]["email"]
    if params["signup"]["email"].empty?
      return erb :index, locals: { errors: "You have to provide and Email" }
    end

    user = User.find_or_create(email)
    if user.valid?
      session["user_token"] = user.token
      erb :index, locals: locals_with(token: user.token)
    else
      erb :index, locals: locals_with(errors: user.errors)
    end
  end

  private

  def locals_with hash
    { errors: [], token: false }.merge hash
  end
end

# TODO create the user in the sync gateway username is email password is the token
# TODO present the user with the JSON documents he should store under his user
