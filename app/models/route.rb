class Route < ActiveRecord::Base
  has_many :waypoints, dependent: :destroy
  has_many :route_translations, dependent: :destroy
  has_and_belongs_to_many :places

  accepts_nested_attributes_for :route_translations

  def title
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").title
    else
      ""
    end
  end

  def subtitle
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").subtitle
    else
      ""
    end
  end

  def as_json(_options = {})
    {
      "id" => id,
      "title" => "route_#{id}_title",
      "subtitle" => "route_#{id}_subtitle",
      "places" => place_order,
      "waypoints" => waypoints
    }
  end

end
