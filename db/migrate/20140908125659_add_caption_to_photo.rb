class AddCaptionToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :caption, :string, default: ''
  end
end
