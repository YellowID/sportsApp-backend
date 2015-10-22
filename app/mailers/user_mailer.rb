class UserMailer < ActionMailer::Base
  default from: 'start_sport@example.com'

  def invite_email(user, email)
    @user = user
    mail(to: email, subject: I18n.t('invite_email.subject'))
  end
end
