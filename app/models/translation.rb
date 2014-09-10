class Translation < ActiveRecord::Base
  belongs_to :place
  validates :language, presence: true, unless: :title_empty?

  def title_empty?
    title.empty?
  end

  def as_json(_options = {})
    {
      "#{json_title}_title" => title,
      "#{json_title}_subtitle" => subtitle
    }
  end

  private

  def json_title
    place.identifier.downcase.tr(' ', '_')
  end
end
