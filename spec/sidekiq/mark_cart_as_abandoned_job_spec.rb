require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  before do
    # Sidekiq configuration for testing
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!
  end

    # Configure test data for carts abandoned for more than 3 hours
  let!(:active_cart) do
    Cart.create!(total_price: 10.0, last_interaction_at: 4.hours.ago, abandoned: false)
  end

    # Configure test data for carts not abandoned
  let!(:recent_cart) do
    Cart.create!(total_price: 5.0, last_interaction_at: 1.hour.ago, abandoned: false)
  end

    # Configure test data for carts abandoned for more than 7 days
  let!(:old_abandoned_cart) do
    Cart.create!(total_price: 20.0, last_interaction_at: 8.days.ago, abandoned: true)
  end

    # Configure test data for carts abandoned less than 7 days ago
  let!(:recent_abandoned_cart) do
    Cart.create!(total_price: 15.0, last_interaction_at: 2.days.ago, abandoned: true)
  end

  describe "#perform" do
    context "marking inactive carts as abandoned" do
      it "marks carts inactive for more than 3 hours as abandoned" do
        MarkCartAsAbandonedJob.new.perform

        expect(active_cart.reload.abandoned).to be true
        expect(recent_cart.reload.abandoned).to be false
      end

      it "does nothing if all carts are recent" do
        Cart.update_all(last_interaction_at: Time.current, abandoned: false)

        expect { MarkCartAsAbandonedJob.new.perform }.not_to change { Cart.where(abandoned: true).count }
      end
    end

    context "removing carts abandoned for more than 7 days" do
      it "removes old abandoned carts" do
        expect {
          MarkCartAsAbandonedJob.new.perform
        }.to change { Cart.exists?(old_abandoned_cart.id) }.from(true).to(false)

        expect(Cart.exists?(recent_abandoned_cart.id)).to be true
      end

      it "does nothing if no carts are old enough to remove" do
        Cart.update_all(last_interaction_at: 2.days.ago, abandoned: true)

        expect { MarkCartAsAbandonedJob.new.perform }.not_to change { Cart.count }
      end
    end
  end
end

