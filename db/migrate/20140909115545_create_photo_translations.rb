class CreatePhotoTranslations < ActiveRecord::Migration
  def change
    create_table :photo_translations do |t|
      t.integer :photo_id
      t.string :language
      t.string :caption, default: ''

      t.timestamps
    end
  end
end
