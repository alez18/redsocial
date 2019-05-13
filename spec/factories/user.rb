FactoryBot.define do
  factory :user do
  	sequence(:email){|n| "dummy_#{n}@factory.com"}
  end
end
