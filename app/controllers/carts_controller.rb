class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_cart
  end

  private

  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id], user_id: current_user.id)
      return cart if cart
    end

    cart = current_user.cart || current_user.create_cart
    session[:cart_id] = cart.id
    cart
  end
end
