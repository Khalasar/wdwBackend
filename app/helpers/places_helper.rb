module PlacesHelper

  def translations_empty?
    @place.translations.first.language.empty?
  end

end
