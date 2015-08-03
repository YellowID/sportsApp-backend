class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_type
  has_many :game_members
  has_many :members, -> { where("state = ? OR state = ?", :confirmed, :possible) }, through: :game_members, source: :user
  has_many :invitations

  validates :user, :sport_type, :age, :start_at, :level,
    :numbers, :title, :latitude, :longitude, presence: true
end
