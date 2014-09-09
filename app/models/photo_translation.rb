class PhotoTranslation < ActiveRecord::Base
  belongs_to :photo
  validates :language, presence: true, unless: :caption_empty?

  def caption_empty?
    caption.empty?
  end

  def as_json(_options = {})
    {
      "#{json_title}_#{photo.id}_caption" => caption
    }
  end

  private

  def json_title
    photo.place.identifier.downcase.tr(' ', '_')
  end
end
