module PlacesHelper
  def translations_empty?
    @place.translations && @place.translations.first &&
    @place.translations.first.language.empty?
  end
end
