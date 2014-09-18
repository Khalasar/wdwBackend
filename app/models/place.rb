class Place < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :identifier,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-zA-Z]+\z/,
                      message: 'only allows letters'
                    }

  has_many :photos, dependent: :destroy
  has_many :translations, dependent: :destroy
  has_and_belongs_to_many :routes

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :translations

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
    translations.find_by_language('en') &&
    translations.find_by_language('en').title
  end

  def subtitle
    translations.find_by_language('en') &&
    translations.find_by_language('en').subtitle
  end

  private

  def photo_array
    photos.map do |p|
      p.as_json
    end
  end

  def json_title
    identifier.downcase.tr(' ', '_')
  end
end
