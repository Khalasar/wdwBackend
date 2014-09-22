class RemoveIdentifierFromPlace < ActiveRecord::Migration
  def change
    remove_column :places, :identifier, :string
  end
end
