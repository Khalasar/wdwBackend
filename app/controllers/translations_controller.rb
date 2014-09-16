class TranslationsController < ApplicationController
  def index
    translations = {}
    photo_translations = {}
    route_translations = {}
    supported_languages.each do |lang|
      translations[lang] = Translation.where(language: "#{lang}")
      photo_translations[lang] = PhotoTranslation.where(language: "#{lang}")
      route_translations[lang] = RouteTranslation.where(language: "#{lang}")
    end

    translations_json = {}
    photo_translations_json = {}
    route_translations_json = {}
    supported_languages.each do |lang|
      translations_json[lang] = convert_json(translations[lang])
      photo_translations_json[lang] = convert_json(photo_translations[lang])
      route_translations_json[lang] = convert_json(route_translations[lang])
    end

    render json: translations_json.deep_merge(photo_translations_json).deep_merge(route_translations_json)
  end

  private

  def convert_json(translations)
    json = {}

    if translations
      translations.as_json.each do |trans|
        json = json.merge(trans)
      end
    end

    json
  end

  def supported_languages
    @supported_languages = [:de, :en, :pl]
  end
end
