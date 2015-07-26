FactoryGirl.define do
  factory :invitation do
    user
    game
    association :owner, factory: :user
  end
end



