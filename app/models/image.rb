class Image < ActiveRecord::Base
  mount_uploader :file, AssetUploader

  belongs_to :place
end
