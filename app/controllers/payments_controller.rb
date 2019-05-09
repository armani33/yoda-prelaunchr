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

    # if the email used for the order is the same of
    if User.find_by_email(customer.email)
      @user = User.find_by_email(customer.email)
      @user.stripe_email = customer.email
      @user.save
    end

    charge = Stripe::Charge.create(
      customer:     customer.id,
      amount:       @amount,
      description:  "YodaCity: Pre-order 150 Unlocks + 400 Minutes.  Order number  #{ 333 + @order.id}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid', email: "#{customer.email}")

    UserMailer.confirm_preorder_email(@order, @user).deliver_now

    redirect_to order_path(@order)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to refer_a_friend_path(@order)
  end
end
