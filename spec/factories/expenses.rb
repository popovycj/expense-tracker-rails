FactoryBot.define do
  factory :expense do
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    description { Faker::Lorem.sentence }
    visibility { :public }
    user
    category
  end
end
