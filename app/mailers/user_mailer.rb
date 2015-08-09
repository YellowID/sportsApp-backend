class UserMailer < ActionMailer::Base
  default from: 'start_sport@example.com'

  def invite_email(user, email)
    @user = user
    mail(to: email, subject: 'Join to StartSport')
  end
end

