class Cart < ApplicationRecord
  belongs_to :user, optional: true # 必須ではないことを意味するoptional: trueを設定
  has_many :cart_items, dependent: :destroy
end
