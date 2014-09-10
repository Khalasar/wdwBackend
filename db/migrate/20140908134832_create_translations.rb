class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :place_id
      t.string :title
      t.string :subtitle

      t.timestamps
    end
  end
end
