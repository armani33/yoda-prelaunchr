# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/signup_email
  def signup_email
    user = User.last
    UserMailer.signup_email(user)
  end

  def confirm_preorder_email
    order = Order.last
    UserMailer.confirm_preorder_email(order)
  end
end
