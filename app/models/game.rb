class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_type
  has_many :game_members
  has_many :members, through: :game_members, source: :user

  validates :user, :sport_type, :age, :start_at,
            :level, :numbers, presence: true
end
