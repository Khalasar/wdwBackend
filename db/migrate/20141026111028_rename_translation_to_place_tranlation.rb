class RenameTranslationToPlaceTranlation < ActiveRecord::Migration
  def change
  	rename_table :translations, :place_translations
  end
end
