class Place < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :title, presence: true

  has_many :photos, :dependent => :destroy
  # enable nested attributes for photos through album class
  accepts_nested_attributes_for :photos, allow_destroy: true

  def as_json(options={})
    {
      "#{id}" => {
        "id" => id,
        "title" => title,
        "lat" => lat,
        "lng" => lng,
        "subtitle" => subtitle,
        "images_count" => 1
      }
    }
  end
end
