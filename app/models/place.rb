class Place < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :title, presence: true

  has_many :photos, :dependent => :destroy
  # enable nested attributes for photos through album class
  accepts_nested_attributes_for :photos, allow_destroy: true

  mount_uploader :german_text, FileUploader
  mount_uploader :english_text, FileUploader

  def as_json(options={})

  photo_array = photos.map do |p|
    { :id => p.id, :caption => p.caption }
  end

    {
      "id" => id,
      "title" => title,
      "lat" => lat,
      "lng" => lng,
      "subtitle" => subtitle,
      "images_count" => photos.count,
      "photos" => photo_array
    }
  end
end
