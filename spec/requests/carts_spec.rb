require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /cart/add_items" do
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }

    # The pending test 
    context "when the product is new to the cart" do
      it "creates a new cart item" do
        # Ensure the cart used by the controller is the first one
        cart = Cart.first_or_create!(total_price: 0.0)

        expect {
          post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        }.to change { cart.cart_items.count }.by(1)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["cart_item"]["quantity"]).to eq(1)
        expect(json["message"]).to eq("Item added to cart successfully")
      end
    end

    context "when the product already is in the cart" do
      it "increments the quantity of the existing cart item" do
        cart = Cart.first_or_create!(total_price: 0.0)
        cart_item = CartItem.create!(cart: cart, product: product, quantity: 1)

        expect {
          2.times do
            post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
          end
        }.to change { cart_item.reload.quantity }.from(1).to(3)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["cart_item"]["quantity"]).to eq(3)
        expect(json["message"]).to eq("Item added to cart successfully")
      end
    end
  end
end
