class UsersController < ApplicationController
  before_action :skip_first_page, only: :new
  before_action :set_variant, only: [:new, :refer]
  # before_action :handle_ip, only: :create

  def new
    @user = User.new

    respond_to do |format|
      format.html(&:phone)
      # do |html|
      # html.phone
      # html.tablet
      # end
    end
  end

  def new_index
    @user = User.new
  end

  def create
    ref_code = cookies[:h_ref]
    @user = User.new(user_params)
    @user.referrer = User.find_by_referral_code(ref_code) if ref_code

    if @user.save
      cookies[:h_email] = { value: @user.email }
      redirect_to refer_a_friend_path
    else
      logger.info("Error saving user with email, #{user_params}")
      redirect_to root_path, alert: 'Something went wrong!'
    end
  end

  def refer
    @nav_link_refer = true
    @user = User.find_by_email(cookies[:h_email])

    respond_to do |format|
      if @user.nil?
        format.html { redirect_to root_path, alert: 'Something went wrong!' }
      else
        format.html # refer.html.erb
      end
    end
  end

  def policy
  end

  def redirect
    redirect_to root_path, status: 404
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def skip_first_page
    return if Rails.application.config.ended

    email = cookies[:h_email]
    if email && User.find_by_email(email)
      redirect_to refer_a_friend_path
    else
      cookies.delete :h_email
    end
  end

  def set_variant
    case request.user_agent
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Windows Phone/i
      request.variant = :phone
    # when /Android/i
    #   request.variant = :tablet
    # when /iPad/i
    #   request.variant = :tablet
    end
  end

  # def handle_ip
  #   # Prevent someone from gaming the site by referring themselves.
  #   # Presumably, users are doing this from the same device so block
  #   # their ip after their ip appears three times in the database.

  #   address = request.env['HTTP_X_FORWARDED_FOR']
  #   return if address.nil?

  #   current_ip = IpAddress.find_by_address(address)
  #   if current_ip.nil?
  #     current_ip = IpAddress.create(address: address, count: 1)
  #   elsif current_ip.count > 2
  #     logger.info('IP address has already appeared three times in our records.
  #                Redirecting user back to landing page.')
  #     return redirect_to root_path
  #   else
  #     current_ip.count += 1
  #     current_ip.save
  #   end
  # end
end
