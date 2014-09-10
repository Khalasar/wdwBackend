class RenameTitleToIdentifierInPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :title, :identifier
  end
end
