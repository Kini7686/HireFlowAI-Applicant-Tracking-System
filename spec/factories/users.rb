FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :candidate }

    trait :admin do
      role { :admin }
    end

    trait :recruiter do
      role { :recruiter }
    end

    trait :candidate do
      role { :candidate }
    end
  end
end
