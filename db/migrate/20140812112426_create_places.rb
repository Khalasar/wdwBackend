class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title, null: false
      t.string :subtitle
      t.text :description
      t.float :lat, null: false
      t.float :lng, null: false

      t.timestamps
    end
  end
end
