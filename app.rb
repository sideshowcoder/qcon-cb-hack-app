require "sinatra"
require "sinatra/twitter-bootstrap"
require "user"
require "sync_gateway_user"

class App < Sinatra::Base

  configure do
    set :session_secret, ENV["SESSION_SECRET"]
    set :root, File.dirname(__FILE__)
    enable :sessions
  end

  register Sinatra::Twitter::Bootstrap::Assets

  get "/" do
    erb :index, locals: locals(token: session["user_token"],
                               email: session["user_email"])
  end

  post "/signup" do
    email = params["signup"]["email"]
    if params["signup"]["email"].empty?
      return erb :index, locals: locals(errors: ["You have to provide and Email"])
    end

    user = User.find_or_create(email)
    if user.valid?
      session["user_token"] = user.token
      session["user_email"] = user.email
      redirect "/"
    else
      erb :index, locals: locals(errors: user.errors)
    end
  end

  post "/signout" do
    session["user_token"] = nil
    session["user_email"] = nil
    redirect "/"
  end

  private

  def locals hash = {}
    { errors: [], token: false, email: false }.merge hash
  end
end

# TODO create the user in the sync gateway username is email password is the token
# TODO present the user with the JSON documents he should store under his user
