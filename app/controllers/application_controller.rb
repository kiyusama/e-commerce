class ApplicationController < ActionController::Base
    helper_method :current_cart

    private

    def current_cart
        #@current_cartを使うことでキャッシュを有効にできる
        return @current_cart if @current_cart

        if session[:cart_id]
          @current_cart = Cart.find_by(id: session[:cart_id], user_id: current_user.id)
          return @current_cart if @current_cart
        end
        #current_userはdeviseのメソッド
        #create_cartはhas_one :cartで自動生成されるメソッド
        @current_cart = current_user.create_cart
        session[:cart_id] = @current_cart.id
        @current_cart
    end
end
