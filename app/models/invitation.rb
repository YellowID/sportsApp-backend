class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :owner, class: User

  validates :user, :game, :owner, presence: true

  def confirm!
    update(confirmed: true)
  end
end

