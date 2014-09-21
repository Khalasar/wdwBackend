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

    translations_one = translations_json.deep_merge(photo_translations_json).deep_merge(route_translations_json)

    render json: translations_one.deep_merge(other_translations)
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

  def other_translations
    {
      :en => {
        "backBtn" => "Back",
        "placesBtn" => "Places of Interest",
        "routesBtn" => "Route selection",
        "downloadBtn" => "Download",
        "onMapBtn" => "View on map",
        "audioLabel" => "Audio-Settings",
        "langSettingsLabel" => "Language-Settings",
        "fontSizeLabel" => "Font-size",
        "language" => "Language",
        "settingsHeadline" => "Settings",
        "audioGuideLabel" => "Audio-Guide",
        "mapLabel" => "Map",
        "city" => "City",
        "region" => "Region",
        "country" => "Country",
        "tour_type" => "Type of tour",
        "BEAR_LEFT" => "Bear left.",
        "GO_LEFT" => "Turn left next opportunity.",
        "SHARP_LEFT" => "Take a sharp left turn.",
        "GO_BACK" => "Continue straight ahead.",
        "SHARP_RIGHT" => "ake a sharp right turn.",
        "GO_RIGHT" => "Turn right next opportunity.",
        "BEAR_RIGHT" => "Bear right.",
        "GO_FORWARD" => "Continue straight ahead.",
        "startBtn" => "Start",
        "pauseBtn" => "Pause",
        "yes" => "Yes",
        "no" => "No",
        "cancelMSG" => "Are you sure route cancelled?",
        "warning" => "Warning",
        "networkError" => "Please check your network connection or that you are not in airplane mode!",
        "unknownNetworkError" => "Unknown network error!",
        "deniedLocationError" => "You deny to use current Location.",
        "errorLabel" => "Error",
        "okLabel" => "Ok",
        "noCompassError" => "This device does not have the ability to measure magnetic fields.",
        "noCompassTitle" => "No compass!",
        "noPlacesMSG" => "No places of interest are available! Please push the Download-Button on the Home page, to download the places."
        },
      :de => {
        "backBtn" => "Zurück",
        "placesBtn" => "Sehenswürdigkeiten",
        "routesBtn" => "Routen-Auswahl",
        "downloadBtn" => "Download",
        "onMapBtn" => "Auf Karte anzeigen",
        "audioLabel" => "Audio-Einstellungen",
        "langSettingsLabel" => "Sprachen-Einstellungen",
        "fontSizeLabel" => "Schriftgröße",
        "language" => "Sprache",
        "settingsHeadline" => "Einstellungen",
        "audioGuideLabel" => "Audio-Guide",
        "mapLabel" => "Karte",
        "city" => "Stadt",
        "region" => "Region",
        "country" => "Land",
        "tour_type" => "Art der Tour",
        "BEAR_LEFT" => "Links halten.",
        "GO_LEFT" => "Bei der nächsten Möglichkeit links gehen.",
        "SHARP_LEFT" => "Scharf nach links abbiegen.",
        "GO_BACK" => "Umdrehen.",
        "SHARP_RIGHT" => "Scharf nach rechts abbiegen.",
        "GO_RIGHT" => "Bei der nächsten Möglichkeit rechts gehen.",
        "BEAR_RIGHT" => "Rechts halten.",
        "GO_FORWARD" => "Wenn möglich, weiter gerade aus gehen.",
        "startBtn" => "Start",
        "pauseBtn" => "Pause",
        "yes" => "Ja",
        "no" => "Nein",
        "cancelMSG" => "Sind Sie sicher, die Route wird beendet?",
        "warning" => "Warnung",
        "networkError" => " Bitte überprüfen Sie Ihre Netzwerkverbindung oder das Sie sich nicht im Flug-Modus befinden!",
        "unknownNetworkError" => "Unbekannter Netzwerk-Fehler",
        "deniedLocationError" => "Sie verbieten das Erkennen der aktuellen Position!",
        "errorLabel" => "Fehler",
        "okLabel" => "Ok",
        "noCompassError" => "Dieses Gerät verfügt nicht über die Fähigkeit, Magnetfelder zu messen.",
        "noCompassTitle" => "Kein Kompass!",
        "noPlacesMSG" => "Keine Sehenswürdigkeiten verfügbar. Bitte betätigen Sie den Download-Button auf der Start-Seite, um Sehenswürdigkeiten herunter zu laden."
      }
    }
  end
end
