FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "johndoe#{n}@example.com" }
    password { "abracadabra" }

    after(:build)   { |u| u.skip_confirmation_notification! }
    after(:create)  { |u| u.confirm }
  end
end
