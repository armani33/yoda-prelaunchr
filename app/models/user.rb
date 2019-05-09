require 'users_helper'

class User < ApplicationRecord
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id', required: false
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  has_many :orders

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true


  before_create :create_referral_code
  before_create :downcase_email
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => '10 Rides<br>Free',
      'class' => 'two',
      # 'image' =>  ActionController::Base.helpers.asset_path(
      #   'refer/cream-tooltip@2x.png')
    },
    {
      'count' => 10,
      'html' => '20 Rides<br> + 30 minutes Free',
      'class' => 'three',
      # 'image' => ActionController::Base.helpers.asset_path(
      #   'refer/truman@2x.png')
    },
    {
      'count' => 25,
      'html' => '40 Rides<br> + 80 minutes Free<br>+ 1 T-shirt',
      'class' => 'four',
      'image' => asset_path('images/reduc_3.png')
    },
    {
      'count' => 50,
      'html' => '100 Rides<br> + 200 minutes Free<br>+ 1 T-shirt',
      'class' => 'five',
      # 'image' => ActionController::Base.helpers.asset_path(
      #   'refer/blade-explain@2x.png')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def downcase_email
    self.email.downcase!
  end
  def send_welcome_email
    UserMailer.signup_email(self).deliver_now
  end
end


