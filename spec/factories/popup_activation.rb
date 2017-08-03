FactoryGirl.define do
  factory :popup_activation do
    shop
    session_token { SecureRandom.hex(15) }
    customer_id   { SecureRandom.random_number(100) }
    ip            { Faker::Internet.ip_v4_address }
    url           { Faker::Internet.url }
    user_agent    { Faker::Internet.user_agent }
  end
end
