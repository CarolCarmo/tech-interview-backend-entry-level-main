class CartsController < ApplicationController
  # POST /cart/add_items
  def add_items
    # Find the cart by ID from params, or create it if it doesn't exist
    cart = Cart.first_or_create!

    # Find the product to be added
    product = Product.find(params[:product_id])

    # Convert quantity to an integer
    quantity = params[:quantity].to_i

    # Find existing cart item or initialize a new one
    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    
    # Increment the quantity of the cart item
    cart_item.quantity = (cart_item.quantity || 0) + quantity
    cart_item.save!

    # Return the updated cart item as JSON
    render json: { 
      message: 'Item added to cart successfully',
      cart_item: cart_item
    }, status: :ok

  rescue ActiveRecord::RecordNotFound
    # If the cart or product was not found
    render json: { error: 'Cart or Product not found' }, status: :not_found

  rescue StandardError => e
    # Handle other errors
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
