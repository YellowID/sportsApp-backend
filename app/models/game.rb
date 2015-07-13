class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_type

  validates :user, :sport_type, :age, :start_at,
            :level, :numbers, presence: true
end
