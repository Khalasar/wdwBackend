class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :title, null: false
      t.string :subtitle

      t.timestamps
    end
  end
end
