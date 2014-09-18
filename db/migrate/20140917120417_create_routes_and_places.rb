class CreateRoutesAndPlaces < ActiveRecord::Migration
  def change
    create_table :places_routes, id: false do |t|
    	t.references :place
    	t.references :route
    end
    add_index :places_routes, [:place_id, :route_id]
    add_index :places_routes, :route_id
  end
end
