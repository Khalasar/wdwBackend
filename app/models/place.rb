class Place < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true

  has_many :photos, dependent: :destroy
  has_many :place_translations, dependent: :destroy
  has_and_belongs_to_many :routes

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :place_translations

  mount_uploader :german_text, FileUploader
  mount_uploader :english_text, FileUploader

  def as_json(_options = {})
    {
      'id' => "#{id}",
      'title' => "#{json_title}_title",
      'subtitle' => "#{json_title}_subtitle",
      'lat' => lat,
      'lng' => lng,
      'images_count' => photos.count,
      'photos' => photo_array
    }
  end

  def title
    place_translations.find_by_language('de') &&
    place_translations.find_by_language('de').title
  end

  def subtitle
    place_translations.find_by_language('de') &&
    place_translations.find_by_language('de').subtitle
  end

  private

  def photo_array
    photos.map do |p|
      p.as_json
    end
  end

  def json_title
    "#{id}_place"
  end
end
