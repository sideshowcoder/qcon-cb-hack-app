require "sinatra"
require "sinatra/twitter-bootstrap"
require "user"
require "glorify"
require "sync_gateway_user"

class App < Sinatra::Base

  configure do
    set :session_secret, ENV["SESSION_SECRET"]
    set :root, File.dirname(__FILE__)
    enable :sessions
  end

  register Sinatra::Twitter::Bootstrap::Assets
  register Sinatra::Glorify

  get "/" do
    erb :index, locals: defaults
  end

  post "/signup" do
    email = params["signup"]["email"]
    if params["signup"]["email"].empty?
      return erb :index, locals: defaults.merge(errors: ["You have to provide and Email"])
    end

    user = User.find_or_create(email)
    if user.valid?
      session["user_token"] = user.token
      session["user_email"] = user.email
      redirect "/"
    else
      erb :index, locals: defaults.merge(errors: user.errors)
    end
  end

  post "/signout" do
    session["user_token"] = nil
    session["user_email"] = nil
    redirect "/"
  end

  private

  def completed?
    return false unless session["user_email"]

    User.find(session["user_email"]).completed?
  end

  def defaults
    {
      errors: [],
      user_token: session["user_token"],
      user_email: session["user_email"],
      user_json: '{"foo":"bar", "key": 1}',
      email: session["user_email"] || "me@example.com",
      token: session["user_token"] || "ABC123",
      sync_gateway_url: ENV["SYNC_GATEWAY_URL"],
      completed: completed?
    }

  end
end

# TODO create the user in the sync gateway username is email password is the token
# TODO present the user with the JSON documents he should store under his user
