FactoryBot.define do
  factory :application do
    association :user, factory: [:user, :candidate]
    association :job
    status { :applied }
  end
end
