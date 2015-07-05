class SportType < ActiveRecord::Base
  validates :name, presence: true
end
