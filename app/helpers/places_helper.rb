module PlacesHelper
  def translations_empty?
    @place.place_translations && @place.place_translations.first.language.empty?
  end
end
