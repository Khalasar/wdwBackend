class CreateRouteTranslations < ActiveRecord::Migration
  def change
    create_table :route_translations do |t|
      t.integer :route_id
      t.string :language
      t.string :title
      t.string :subtitle

      t.timestamps
    end
  end
end
