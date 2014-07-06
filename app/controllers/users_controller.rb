class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create, :forgot_pwd]

#render new form
  def new
    @user = User.new
  end

#create a new user account
  def create
    @user = User.new(params[:user])
    token = generate_token()
    if @user.valid?
      @token = @user.user_tokens.create(token_type: 'activate',token:  token, expires_after: 2.hours.from_now)
      @token.save
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

  def verify_email
    mytoken = params.first[0]
    @token = UserToken.find_by_token(mytoken)
    @user = User.find_by_id(@token.user_id)
    if @user
      @user.update_attributes(:is_active => 1, :activated_at => Time.now)
      flash[:notice] = "user activated"
    end
  end


#render forgot password view
  def forgot_pwd
    @user = User.new
  end

#request new password
  def request_pwd
    username_or_email = params[:user][:username]

    if username_or_email.rindex('@')
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end

    if user
      user.password_reset_token = SecureRandom.urlsafe_base64
      user.password_expires_after = 2.hours.from_now
      user.save
      UserMailer.reset_password_email(user).deliver
      flash[:notice] = 'Password instructions have been mailed to you. Please check your inbox.'
      render 'home'
    else
      @user = User.new
      # put the previous value back.
      @user.username = params[:user][:username]
      flash[:notice] = 'is not a registered user.'
      render 'home'
    end
  end


# prevalidation before user can see password reset form
  def password_reset
    #this ensures that the user is allowed to reset the password by checking the token.
    token = params.first[0]
    @user = User.find_by_password_reset_token(token)

    if @user.nil?
      flash[:error] = 'You have not requested a password reset.'
      render :root
      return
    end

    if @user.password_expires_after < DateTime.now
      @user.clear_password_reset
      @user.save
      flash[:error] = 'Password reset has expired. Please request a new password reset.'
      render :forgot_password
    end
  end

#finally set a new password
  def create_new_pwd
    username = params[:user][:username]
    @user = User.find_by_username(username)

    if @user.valid?
      @user.clear_password
      @user.update_attributes(params[:user])
      flash[:notice] = 'Your password has been reset. Please sign in with your new password.'
      redirect_to :home
    else
        redirect_to :action => "password_new"
    end
  end

  def generate_token
    return token = SecureRandom.urlsafe_base64
  end
end
