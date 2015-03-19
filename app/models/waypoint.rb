class Waypoint < ActiveRecord::Base
  belongs_to :route

  def as_json(_options = {})
    {
      'lat' => lat,
      'lng' => lng
    }
  end
end
