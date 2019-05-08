class PaymentsController < ApplicationController
  def new
  end

  def create
    pre_product = Product.first
    @order  = Order.create!(amount: pre_product.price, state: 'pending')

    @amount = @order.amount_cents

    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @amount,
      description:  "Payment for 150 Unlocks + 400 Minutes.  Order number  #{ 333 + @order.id}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid')
    redirect_to order_path(@order)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to refer_a_friend_path(@order)
  end
end
