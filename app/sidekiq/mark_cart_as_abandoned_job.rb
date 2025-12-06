class MarkCartAsAbandonedJob
  include Sidekiq::Job

  # This job implements the logic to mark carts as abandoned after 3 hours of inactivity
  # and remove carts that have been abandoned for more than 7 days.

  def perform
    # Mark carts as abandoned if inactive for more than 3 hours
    Cart.where('last_interaction_at < ? AND abandoned = ?', 3.hours.ago, false).find_each do |cart|
      cart.mark_as_abandoned
    end

    # Remove carts that have been abandoned for more than 7 days
    Cart.where('last_interaction_at < ? AND abandoned = ?', 7.days.ago, true).find_each do |cart|
      cart.remove_if_abandoned
    end
  end
end
