class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :ref_to_cookie

  protected

  def ref_to_cookie
    campaign_ended = Rails.application.config.ended
    return if campaign_ended || !params[:ref]

    unless User.find_by_referral_code(params[:ref]).nil?
      h_ref = { value: params[:ref], expires: 52.week.from_now }
      cookies[:h_ref] = h_ref
    end

    user_agent = request.env['HTTP_USER_AGENT']
    return unless user_agent && !user_agent.include?('facebookexternalhit/1.1')

    redirect_to(proc { url_for(params.to_unsafe_h.except(:ref).merge(only_path: true)) })
  end
end
