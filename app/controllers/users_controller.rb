class UsersController < ApplicationController
  before_action :skip_first_page, only: :new
  before_action :set_variant, only: [:new, :refer]
  before_action :handle_ip, only: :create

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

    if User.find_by_email(@user.email).nil?
      if @user.save
        cookies[:h_email] = { value: @user.email, expires: 52.week.from_now }
        redirect_to refer_a_friend_path
      else
        logger.info("Error saving user with email, #{user_params}")
        redirect_to root_path, alert: 'This user already subscribed'
      end
    else
      logger.info("Error saving user with email, #{user_params}")
      redirect_to root_path, alert: 'This user already subscribed'
    end
  end

  def refer
    session[:expires_at] = Time.now + 5
    @nav_link_refer = true
    @user = User.find_by_email(cookies[:h_email])

    @product = Product.first

    if @user.nil?
      respond_to do |format|
        format.html(&:phone)
        redirect_to root_path, alert: 'Something went wrong!'
      end
    else
      respond_to do |format|
        format.html(&:phone) # refer.html.erb
      end
    end
  end

  def policy
  end

  def redirect
    redirect_to root_path, status: 404
  end


  def already_subscribe
    @user = User.new
  end

  def check_email
    user = User.find_by_email(params[:user][:email])
    if !(user.nil?)
      referral_code = user.referral_code

      UserMailer.already_subscribe_email(user, referral_code).deliver_now
      redirect_to already_subscribe_path, alert: 'An email has been send to you '
    else
      redirect_to already_subscribe_path, alert: 'This email does not exist in our data base. Sorry.'
    end
  end

  def verification_user_email
    user = User.find_by_referral_code(params[:format])
    cookies[:h_email] = { value: user.email, expires: 52.week.from_now }
    redirect_to refer_a_friend_path
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

  def handle_ip
    # Prevent someone from gaming the site by referring themselves.
    # Presumably, users are doing this from the same device so block
    # their ip after their ip appears three times in the database.

    address = request.remote_ip
    return if address.nil?

    current_ip = IpAddress.find_by_address(address)
    if current_ip.nil?
      current_ip = IpAddress.create(address: address, count: 1)
    elsif current_ip.count > 1
      return redirect_to root_path, notice: 'IP address has already appeared
                                      2 times in our records.
                                      Subscription are blocked to prevent poeple abusing from our rewards. Thank You!'
    else
      current_ip.count += 1
      current_ip.save
    end
  end
end
