FactoryGirl.define do
  factory :game do
    user
    sport_type

    start_at "07.07.2015"
    age 25
    numbers 10
    level 1
    title 'title'
    city 'city'
    address 'address'
    country 'country'
    latitude 1.123
    longitude -1.123
  end
end



