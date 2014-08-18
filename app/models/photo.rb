class Photo < ActiveRecord::Base
  #attr_accessible :image
  #photo belongs to album
  belongs_to  :place
  #validations
  #validates   :place, presence: true
  # Photo uploader using carrierwave
  mount_uploader :file, ImageUploader

  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "delete_url" => "/photos/#{id}",
      "delete_type" => "DELETE"
    }
  end
end
