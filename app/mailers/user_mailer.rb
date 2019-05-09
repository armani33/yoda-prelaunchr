  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/signup_email
class UserMailer < ApplicationMailer
  default from: 'YodaCity <contact@yoda-city.com>'

  def signup_email(user)
    @user = user
    @twitter_message = '#Mobility is evolving. Excited for YodaCity to launch.'

    mail(to: @user.email, subject: 'Thanks for signing up!')
  end

  def confirm_preorder_email(order, user)
    @order = order
    @user = user

    mail(to: @user.email, subject: 'Thank you for your order!')
  end
end
