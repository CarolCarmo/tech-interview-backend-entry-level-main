class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show update destroy ]

  # GET /cart
  def index
    # Find the cart by ID from params, or create it if it doesn't exist
    #TODO: Adjust to get current user's cart
    cart = Cart.first_or_create!   

    # Return the updated cart item as JSON
    render json: { 
      id: cart.id,
      products: cart.cart_items.map { |item| { product_id: item.product_id, name: item.product.name,  quantity: item.quantity,  
                                       unit_price: item.product.price, total_price: item.quantity * item.product.price } },
      total_price: cart.cart_items.sum { |item| item.quantity * item.product.price }
    }, status: :ok
  end
  

  # GET /cart/1
  def show
    render json: @cart
  end

  # POST /cart
  def create
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
      id: cart.id,
      products: cart.cart_items.map { |item| { product_id: item.product_id, name: item.product.name,  quantity: item.quantity,  
                                       unit_price: item.product.price, total_price: item.quantity * item.product.price } },
      total_price: cart.cart_items.sum { |item| item.quantity * item.product.price }
    }, status: :ok
  end

  # PATCH/PUT /cart/1
  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cart/1
  def destroy
    # Find the cart by ID from params, or create it if it doesn't exist
    cart = Cart.first_or_create!

    # Find the product to be deleted
    product = Product.find(params[:id])

    # Find existing cart item or initialize a new one
    cart_item = cart.cart_items.find_or_initialize_by(product: product)

    # Exclude the cart item
    cart_item.destroy!
  end

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
      id: cart.id,
      products: cart.cart_items.map { |item| { product_id: item.product_id, name: item.product.name,  quantity: item.quantity,  
                                       unit_price: item.product.price, total_price: item.quantity * item.product.price } },
      total_price: cart.cart_items.sum { |item| item.quantity * item.product.price }
      
    }, status: :ok

  rescue ActiveRecord::RecordNotFound
    # If the cart or product was not found
    render json: { error: 'Cart or Product not found' }, status: :not_found

  rescue StandardError => e
    # Handle other errors
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:name, :price)
    end
end
