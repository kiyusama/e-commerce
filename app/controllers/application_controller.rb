class ApplicationController < ActionController::Base
    helper_method :current_cart
    protect_from_forgery with: :exception

    private

    def current_cart
      return @current_cart if @current_cart
      
      if current_user
        # ユーザーとカートの紐付け
        @current_cart = current_user.cart || current_user.create_cart!
      else
        # セッションとカートの紐付け
        @current_cart = Cart.find_by(id: session[:cart_id]) || Cart.create
        session[:cart_id] ||= @current_cart.id
        @current_cart
      end
    end
end
