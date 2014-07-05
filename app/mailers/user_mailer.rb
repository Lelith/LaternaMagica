class UserMailer < ActionMailer::Base
  default from: "laternamagica@snowhitepink.com"

  def welcome(user)
    @user = user
    @url  = 'localhost:3000'
    mail(to: @user.email, subject: 'Welcome to LaternaMagica')
  end
end
