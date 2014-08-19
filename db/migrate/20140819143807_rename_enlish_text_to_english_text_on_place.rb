class RenameEnlishTextToEnglishTextOnPlace < ActiveRecord::Migration
  def change
    rename_column :places, :enlish_text, :english_text
  end
end
