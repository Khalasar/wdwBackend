class RouteTranslation < ActiveRecord::Base
  belongs_to :route
  validates :language, presence: true, unless: :title_empty?

  def title_empty?
    title.empty?
  end

  def as_json(_options = {})
    {
      "route_#{route.id}_title" => title,
      "route_#{route.id}_subtitle" => subtitle,
      "route_#{route.id}_country" => country,
      "route_#{route.id}_region" => region,
      "route_#{route.id}_city" => city,
      "route_#{route.id}_description" => description,
      "route_#{route.id}_type" => route_type
    }
  end
end
