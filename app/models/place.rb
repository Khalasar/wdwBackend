class Place < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :title, presence: true
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images

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
