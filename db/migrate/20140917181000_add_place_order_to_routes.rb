class AddPlaceOrderToRoutes < ActiveRecord::Migration
  def change
  	add_column :routes, :place_order, :string
  end
end
