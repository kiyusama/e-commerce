class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = current_user.orders
  end

  def show
    @order_items = @order.order_items
  end

  def create
    @cart = current_cart
    @order = current_user.orders.build(order_params)
    @order.total_price = calculate_total_price(@cart)

    if @order.save
      @cart.cart_items.each do |item|
        @order.order_items.create(product: item.product, quantity: item.quantity, unit_price: item.product.price)
      end
      @cart.cart_items.destroy_all
      redirect_to @order, notice: '注文が正常に作成されました。'
    else
      redirect_to cart_path, alert: '注文を作成できませんでした。'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: '注文が削除されました。'
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.fetch(:order, {}).permit(:status, :address)
  end

  def calculate_total_price(cart)
    cart.cart_items.inject(0) { |sum, item| sum + item.product.price * item.quantity }
  end

  def current_cart
    current_user.cart || current_user.create_cart
  end
end
