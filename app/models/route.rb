class Route < ActiveRecord::Base
  has_many :waypoints, dependent: :destroy
end
