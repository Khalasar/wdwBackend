class AddPlaceIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :place_id, :string
  end
end
