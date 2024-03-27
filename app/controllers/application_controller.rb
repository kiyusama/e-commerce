class ApplicationController < ActionController::Base
  helper_method :current_cart

  def current_cart
    if user_signed_in?
      @current_cart ||= find_or_create_cart
    else
      @current_cart ||= session[:cart] ||= { 'items' => [] }
      normalize_session_cart
    end
    @current_cart
  end

  private

  def find_or_create_cart
    current_user.cart || current_user.create_cart
  end

  def normalize_session_cart
    session[:cart]['items'] = session[:cart]['items'].map do |item|
      # 既存のアイテムはそのまま保持し、新しいアイテムはデフォルトの数量を1で設定
      item['quantity'] = item['quantity'].to_i
      item['quantity'] = 1 if item['quantity'] < 1
      item
    end
  end
end
