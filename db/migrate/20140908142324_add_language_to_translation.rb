class AddLanguageToTranslation < ActiveRecord::Migration
  def change
    add_column :translations, :language, :string
  end
end
