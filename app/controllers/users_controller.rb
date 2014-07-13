class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create, :forgot_pwd, :verify_email]

#render new form
  def new
    @user = User.new
  end

#create a new user account
  def create
    @user = User.new(params[:user])
    if @user.save
      send_activation(@user)
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
    end
    render "new"
  end

  def send_activation(user)
    @user = user
    token = generate_token()
    @token = @user.user_tokens.create(token_type: 'activate', token: token, expires_after: 2.hours.from_now)
    @token.save
     # Tell the UserMailer to send a welcome email after save
    UserMailer.welcome(@user, @token).deliver
    flash[:notice] = "Your regisration e-mail has send"
    flash[:color] = "valid"
  end

  def verify_email
    mytoken = params.first[0]
    @token = UserToken.find_by_token(mytoken)
    if @token
      unless @token.token_type !='activate'
        if @token.expires_after < DateTime.now
          @token.destroy
          flash[:notice] = "The token has already expired, request a new one"
          render "sessions/home"
        else
          @user = User.find_by_id(@token.user_id)
          if @user
            @user.update_attributes(:is_active => 1, :activated_at => Time.now)
            @token.destroy
            flash[:notice] = "user activated"
          else
            flash[:notice] = "does not exist"
            render "sessions/home"
          end
        end
      end
    else
      flash[:notice] = "does not exist"
      render "sessions/home"
    end
  end

  def verification
    @user = User.new
  end

  def request_activation
    username_or_email = params[:user][:username]
    if username_or_email.rindex('@')
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end

    if user
      send_activation(user)
    else
      flash[:notice] = "sorry you're not a registered user"
      render "new"
    end
    render "sessions/login"
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
      token = generate_token()
      pwd_token = user.user_tokens.create(token_type: 'password', token: token, expires_after: 2.hours.from_now)
      pwd_token.save
      UserMailer.reset_password_email(user,pwd_token ).deliver
      flash[:notice] = 'Password instructions have been mailed to you. Please check your inbox.'
      render 'sessions/login'
    else
      @user = User.new
      # put the previous value back.
      @user.username = params[:user][:username]
      flash[:notice] = 'is not a registered user.'
      render 'sessions/login'
    end
  end


# prevalidation before user can see password reset form
  def password_reset
    #this ensures that the user is allowed to reset the password by checking the token.
    token = params.first[0]
    @token = UserToken.find_by_token(token)
    if @token
      unless @token.token_type !='password'
        if @token.expires_after < DateTime.now
          @token.destroy
          render "forgot_pwd"
          flash[:notice] = 'Password reset has expired. Please request a new password reset.'
          return
        else
          @user = User.find_by_id(@token.user_id)
          if @user.nil?
            flash[:notice] = 'You have not requested a password reset.'
            render "login"
            return
          end
        end
      end
    else
      render "forgot_pwd"
      flash[:notice] = 'You have not requested a password reset.'
      return
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
