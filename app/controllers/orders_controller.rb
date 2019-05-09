class OrdersController < ApplicationController
  def show
    @order = Order.last
  end
end
