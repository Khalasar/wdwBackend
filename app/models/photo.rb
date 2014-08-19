class Photo < ActiveRecord::Base
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
      "delete_url" => "/places/#{place_id}/photos/#{id}",
      "delete_type" => "DELETE"
    }
  end
end
