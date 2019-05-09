class OrdersController < ApplicationController
  def show
    @user = User.find_by_email(cookies[:h_email])
    @order = Order.last
  end
end
