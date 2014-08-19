class AddTranslatedDescriptionToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :german_text, :string
    add_column :places, :enlish_text, :string
  end
end
