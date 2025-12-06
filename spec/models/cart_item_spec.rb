require 'rails_helper'

RSpec.describe CartItem, type: :model do

  describe 'validations' do
    it 'is valid with quantity greater than 0' do
      cart = Cart.create!(total_price: 0.0)
      product = Product.create!(name: 'Valid Qty Product', price: 2.0)
      ci = CartItem.new(cart: cart, product: product, quantity: 1)

      expect(ci).to be_valid
    end

    it 'validates uniqueness of product per cart' do
      cart = Cart.create!(total_price: 0.0)
      product = Product.create!(name: 'Unique Prod', price: 3.0)
      CartItem.create!(cart: cart, product: product, quantity: 1)

      duplicate = CartItem.new(cart: cart, product: product, quantity: 2)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:product_id]).to be_present
    end
  end
end
