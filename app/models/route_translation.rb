class RouteTranslation < ActiveRecord::Base
  belongs_to :route
  validates :language, presence: true, unless: :title_empty?

  def title_empty?
    title.empty?
  end

  def as_json(_options = {})
    {
      "route_#{route.id}_title" => title,
      "route_#{route.id}_subtitle" => subtitle
    }
  end
end
