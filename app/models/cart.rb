class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  
  has_many :cart_items, dependent: :destroy

  before_save :calculate_total

  # Calculate total price before saving
  def calculate_total
    self.total_price = cart_items.sum { |item| item.quantity * item.product.price }
  end

  # Mark the cart as abandoned
  def mark_as_abandoned
    update(abandoned: true) # if there is an 'abandoned:boolean' column
  end

end
