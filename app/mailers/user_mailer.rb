class UserMailer < ActionMailer::Base
  default from: "laternamagica@snowhitepink.com"

  def welcome(user)
    @user = user
    @url  = 'localhost:3000'
    mail(to: @user.email, subject: 'Welcome to LaternaMagica')
  end

  def reset_password_email(user)
    @user = user
    @password_reset_url = 'http://localhost:3000/password_reset?' +     @user.password_reset_token
    mail(:to => @user.email, :subject => 'Password Reset Instructions.')
  end
end
