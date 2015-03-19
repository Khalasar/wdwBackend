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

  def description
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").description
    else
      ""
    end
  end

  def country
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").country
    else
      ""
    end
  end

  def region
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").region
    else
      ""
    end
  end

  def city
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").city
    else
      ""
    end
  end

  def route_type
    if route_translations.find_by_language("de")
      route_translations.find_by_language("de").route_type
    else
      ""
    end
  end

  def as_json(_options = {})
    {
      "id" => id,
      "title" => "route_#{id}_title",
      "subtitle" => "route_#{id}_subtitle",
      "country" => "route_#{id}_country",
      "region" => "route_#{id}_region",
      "city" => "route_#{id}_city",
      "description" => "route_#{id}_description",
      "route_type" => "route_#{id}_type",
      "places" => place_order,
      "waypoints" => waypoints
    }
  end
end
