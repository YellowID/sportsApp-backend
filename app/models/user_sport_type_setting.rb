class UserSportTypeSetting < ActiveRecord::Base
  belongs_to :sport_type
  belongs_to :user
end

