class AddIndexUniqueToTitleOnPlaces < ActiveRecord::Migration
  def change
    add_index :places, :title, :unique => true
  end
end
