 # Preview this email at http://localhost:3000/rails/mailers/user_mailer/signup_email
class UserMailer < ApplicationMailer
  def signup_email(user)
    @user = user
    @twitter_message = '#Mobility is evolving. Excited for YodaCity to launch.'

    mail(to: @user.email, subject: 'Thanks for signing up!')
  end
end
