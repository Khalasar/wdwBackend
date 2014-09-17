class CreateWaypoints < ActiveRecord::Migration
  def change
    create_table :waypoints do |t|
      t.integer :route_id
      t.float :lat, null: false
      t.float :lng, null: false

      t.timestamps
    end
  end
end
