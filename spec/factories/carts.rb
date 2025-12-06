FactoryBot.define do
    factory :cart do
        total_price { 0.0 }
        abandoned { false }
        last_interaction_at { Time.now }
    end
end