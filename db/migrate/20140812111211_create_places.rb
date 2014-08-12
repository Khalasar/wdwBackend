class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.float :lat, null: false
      t.float :lat, null: false
      t.string :title, null: false
      t.string :subtitle
      t.text :description

      t.timestamps
    end
  end
end
