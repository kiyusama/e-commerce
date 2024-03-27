class CartItemsController < ApplicationController
  def create
    Rails.logger.debug params.inspect

    if user_signed_in?
      # ログインしている場合は、ユーザーのカートにアイテムを追加
      @cart = current_user.cart || current_user.create_cart
      @cart_item = @cart.cart_items.find_by(product_id: cart_item_params[:product_id])

      if @cart_item
        @cart_item.quantity += cart_item_params[:quantity].to_i
      else
        @cart_item = @cart.cart_items.build(cart_item_params)
      end

      if @cart_item.save
        redirect_to cart_path, notice: 'カートに商品を追加しました'
      else
        Rails.logger.debug @cart_item.errors.full_messages.to_sentence
        redirect_to root_path, alert: 'カートに商品を追加できませんでした'
      end
    else
      # ログインしていない場合は、セッションにカートアイテムを追加
      session[:cart] ||= {'items' => []}
      item = session[:cart]['items'].find { |i| i['product_id'] == cart_item_params[:product_id].to_s }
      
      if item
        item['quantity'] += cart_item_params[:quantity].to_i
      else
        session[:cart]['items'] << cart_item_params.to_h.symbolize_keys
      end

      redirect_to cart_path
    end
  end

  def destroy
    @cart_item = current_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "カートから商品を削除しました"
  end
  

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
