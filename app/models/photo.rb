class Photo < ActiveRecord::Base
  # photo belongs to album
  belongs_to  :place
  has_many :photo_translations, dependent: :destroy

  accepts_nested_attributes_for :photo_translations

  # Photo uploader using carrierwave
  mount_uploader :file, ImageUploader

  def caption
    photo_translations.find_by_language('en') &&
    photo_translations.find_by_language('en').caption
  end

  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "delete_url" => "/places/#{place_id}/photos/#{id}",
      "delete_type" => "DELETE"
    }
  end

  def as_json(_options={})
    {
      "id" => id,
      "caption" => "place_#{id}_caption"
    }
  end
end
