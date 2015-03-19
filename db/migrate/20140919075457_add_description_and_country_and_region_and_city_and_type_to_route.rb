class AddDescriptionAndCountryAndRegionAndCityAndTypeToRoute < ActiveRecord::Migration
  def change
    add_column :route_translations, :description, :text
    add_column :route_translations, :country, :string
    add_column :route_translations, :region, :string
    add_column :route_translations, :city, :string
    add_column :route_translations, :type, :string
  end
end
