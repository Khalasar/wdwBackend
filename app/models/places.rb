class Places < ActiveRecord::Base
  validates :lat, presence: true
  validates :lon, presence: true
  validates :title, presence: true
end
