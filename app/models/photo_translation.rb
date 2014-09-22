class PhotoTranslation < ActiveRecord::Base
  belongs_to :photo
  validates :language, presence: true, unless: :caption_empty?

  def caption_empty?
    caption.empty?
  end

  def as_json(_options = {})
    {
      "place_#{photo.id}_caption" => caption
    }
  end
end
