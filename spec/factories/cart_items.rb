FactoryBot.define do
    factory :cart_item do
        association :cart      # Links to a cart record
        association :product   # Links to a product record
        quantity { 1 }         # Sets default quantity to 1
    end
end