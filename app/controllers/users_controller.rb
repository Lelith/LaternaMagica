class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
       # Tell the UserMailer to send a welcome email after save
      UserMailer.welcome(@user).deliver
      flash[:notice] = "You signed up successfully"
      flash[:color] = "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
    end
    render "new"
  end
end
