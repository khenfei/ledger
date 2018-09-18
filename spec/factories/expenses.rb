FactoryBot.define do
  factory :expense do
    category { Expense.categories.keys.sample }
    total { sprintf "%0.02f", Random.new.rand(0.0..100.0) }
    paid_at { Time.now }
    association :owner

    trait :invalid do
      total { -1 }
    end

  end
end
