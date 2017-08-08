FactoryGirl.define do
  factory :popup_submit do
    shop
    session_token { SecureRandom.hex(15) }
    email         { Faker::Internet.email }
    name          { Faker::Name.name }
    url           { Faker::Internet.url }
  end
end
