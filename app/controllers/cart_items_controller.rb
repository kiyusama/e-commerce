class CartItemsController < ApplicationController
    def create
      @cart = current_cart
      @cart_item = @cart.cart_items.find_by(product_id: cart_item_params[:product_id])
      product = Product.find_by(id: cart_item_params[:product_id])

      if @cart_item
        @cart_item.quantity += 1
      else
        # cart_item_paramsにquantityが含まれていない場合はデフォルト値として1を設定
        quantity = cart_item_params[:quantity].presence || 1
        @cart_item = @cart.cart_items.build(product: product, quantity: quantity)
      end

      if @cart_item.save
        redirect_to cart_path, notice: "カートに商品を追加しました"
      else
        Rails.logger.debug @cart_item.errors.full_messages.to_sentence
        redirect_to root_path, alert: "カートに商品を追加できませんでした"
      end
    end

    def destroy
      @cart_item = current_cart.cart_items.find(params[:id])
      @cart_item.destroy
      redirect_to cart_path, notice: "カートから商品を削除しました"
    end

    private

    def cart_item_params
      params.permit(:product_id, :quantity)
    end
end
