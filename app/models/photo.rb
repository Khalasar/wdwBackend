class Photo < ActiveRecord::Base
  #photo belongs to album
  belongs_to  :place
  #validations
  validates   :place, presence: true
  # Photo uploader using carrierwave
  mount_uploader :image, ImageUploader
end
