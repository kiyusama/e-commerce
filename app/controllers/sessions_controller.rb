class SessionsController < Devise::SessionsController
    def create
      super do |user|
        if session[:cart] && session[:cart]['items']
          user_cart = user.cart || user.create_cart
  
          session[:cart]['items'].each do |item_params|
            item = user_cart.cart_items.find_or_initialize_by(product_id: item_params['product_id'])
  
            if item.new_record?
              item.quantity = item_params['quantity'].to_i
            else
              item.quantity += item_params['quantity'].to_i if item.quantity
            end
  
            item.save
          end
  
          session.delete(:cart)
        end
      end
    end
  end
  