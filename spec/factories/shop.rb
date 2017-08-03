FactoryGirl.define do
  factory :shop do
    shopify_domain        { Faker::Internet.domain_name }
    shopify_token         { SecureRandom.hex(15) }
    email                 { Faker::Internet.email }
    password              'password'
    password_confirmation 'password'
  end
end
