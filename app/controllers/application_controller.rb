require "./config/environment"
require "./app/models/user"
require "pry"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  #if the username or password is blank signing up - make a failure
  #if the username or passwrod is not blank, create a new user and redirect them to log in
  post "/signup" do
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
    else
      User.create(username: params[:username], password: params[:password])
      binding.pry
      redirect "/login"
      
    end 
  end

  #find th users account using their specific session id - show the account page
  get "/account" do
    @user = User.find(session[:user_id])
    erb :account
  end


  #show the login page
  get "/login" do
    erb :login
  end

  #The user will type in its username
  #using authenticate - authenticate matches with the model, see if the user and the password match - if they do, set up a session and redirect them to their account
  #if they dont match, fail
  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/account"
    else 
      redirect to "/failure" 
    end
  end

  get "/failure" do
    erb :failure
  end

  #this is standard and will be the same for everything 
  get "/logout" do
    session.clear
    redirect "/"
  end

  #these helpers are pretty standard 
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
