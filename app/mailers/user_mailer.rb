class UserMailer < ActionMailer::Base
  default from: "laternamagica@snowhitepink.com"

  def welcome(user, token)
    @user = user
    @url  = 'localhost:3000/verify?'+token.token
    mail(to: @user.email, subject: 'Welcome to LaternaMagica')
  end

  def reset_password_email(user,token)
    @user = user
    @password_reset_url = 'http://localhost:3000/password_reset?' + @token.token
    mail(:to => @user.email, :subject => 'Password Reset Instructions.')
  end
end
