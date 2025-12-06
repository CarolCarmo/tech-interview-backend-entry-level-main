class CartsController < ApplicationController
  def add_items
    # Retrieve the cart from the session, or create a new one if it doesn't exist
    cart = Cart.find_by(id: session[:cart_id]) || Cart.create!(total_price: 0.0)
    session[:cart_id] ||= cart.id

    # Find the product to be added
    product = Product.find(params[:product_id])

    # Convert quantity to an integer
    quantity = params[:quantity].to_i

    # Find the existing cart item or initialize a new one for the product
    cart_item = cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity ||= 0

    # Increase the quantity of the item in the cart
    cart_item.quantity += quantity
    cart_item.save!

    # Return the updated cart item as JSON
    render json: { 
      message: 'Item added to cart successfully',
      cart_item: cart_item
    }, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
    
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

end
