class CartItemsController < ApplicationController
    def create
      @cart = current_cart
      @cart_item = @cart.cart_items.find_by(product_id: cart_item_params[:product_id])

      if @cart_item
        @cart_item.quantity += 1
      else
        @cart_item = @cart.cart_items.build(cart_item_params)
      end

      if @cart_item.save
        redirect_to cart_path, notice: "カートに商品を追加しました"
      else
        redirect_to root_path, alert: "カートに商品を追加できませんでした"
      end
    end

    def destroy
      @cart_item = CartItem.find(params[:id])
      @cart_item.destroy
      redirect_to cart_path, notice: "カートから商品を削除しました"
    end

    private
    def current_cart
      Cart.find(session[:cart_id])
    end

    def cart_item_params
      params.require(:cart_item).permit(:product_id, :quantity)
    end
end
