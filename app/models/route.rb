class Route < ActiveRecord::Base
  validates :title, presence: true
  has_many :waypoints, dependent: :destroy

  def as_json(_options = {})
    {
      "id" => id,
      "title" => "#{id}_title",
      "subtitle" => "#{id}_subtitle",
      "waypoints" => waypoints
    }
  end

end
