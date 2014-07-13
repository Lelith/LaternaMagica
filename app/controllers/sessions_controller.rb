class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting]
  before_filter :save_login_state, :only => [:login, :login_attempt]

  def login
    # shows login form
  end

  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

  def login_attempt
     authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
     if authorized_user
        if authorized_user.is_active
          session[:user_id] = authorized_user.id
          flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
          redirect_to(:action => 'home')
        else
          flash[:notice] = "Sorry you are not veryfied"
          render 'users/verification'
        end
     else
        flash[:notice] = "Invalid Username or Password"
        flash[:color]= "invalid"
        render "login"
     end
  end

  def home
  end

  def profile
  end

  def setting
  end
end
