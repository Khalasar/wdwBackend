class RenameTypeToRouteType < ActiveRecord::Migration
  def change
    rename_column :route_translations, :type, :route_type
  end
end
