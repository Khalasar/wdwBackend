class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :description
      t.string :file

      t.timestamps
    end
  end
end
