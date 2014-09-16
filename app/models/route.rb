class Route < ActiveRecord::Base
  validates :title, presence: true
  has_many :waypoints, dependent: :destroy
end
