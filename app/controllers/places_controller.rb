require 'zip'

class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy, :get_images]
  before_action :supported_languages

  def get_images
    photos = @place.photos
    photo_files = {}
    text_files = {}
    text_files["en_text"] = @place.english_text.file.path if @place.english_text.file
    text_files["de_text"] = @place.german_text.file.path if @place.german_text.file
    photos.each do |photo|
      photo_files[photo.name] = photo.file.path if File.exist?(photo.file.path)
    end
    zip_and_send(photo_files, text_files, @place.id)
  end

  def translations
    translations = {}
    photo_translations = {}
    supported_languages.each do |lang|
      translations[lang] = Translation.where(language: "#{lang}")
      photo_translations[lang] = PhotoTranslation.where(language: "#{lang}")
    end

    translations_json = {}
    photo_translations_json = {}
    supported_languages.each do |lang|
      translations_json[lang] = convert_json(translations[lang])
      photo_translations_json[lang] = convert_json(photo_translations[lang])
    end

    translations_one = translations_json.deep_merge(photo_translations_json)

    render json: translations_one.deep_merge(other_translations)
  end

  # GET /places
  # GET /places.json
  def index
    @places = Place.all

    respond_to do |format|
      format.html
      format.json { render json: @places }
    end
  end

  # GET /places/1
  # GET /places/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @place }
    end
  end

  # GET /places/new
  def new
    @place = Place.new
    supported_languages.count.times { @place.translations.build }
  end

  # GET /places/1/edit
  def edit
    new_languages = supported_languages.count - @place.translations.count
    new_languages.times { @place.translations.build }
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    if @place.save
      if params[:images]
        params[:images].each do |image|
          @place.photos.create(image: image)
        end
      end
    end

    respond_to do |format|
      if @place.save
        format.html do
          redirect_to new_place_photo_path(@place),
                      notice: 'Place was successfully created.'
        end
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        if params[:images]
          params[:images].each do |image|
            @place.photos.create(image: image)
          end
        end
        format.html do
          redirect_to @place, notice: 'Place was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html do
        redirect_to places_url, notice: 'Place was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def place_params
    params.require(:place).permit(
      :identifier,
      :description,
      :lat,
      :lng,
      :english_text,
      :german_text,
      translations_attributes: [:id, :title, :subtitle, :language])
  end

  def zip_and_send(photo_files, text_files, place_id)
    zipfile_name = "#{place_id}.zip"
    temp_file = Tempfile.new(zipfile_name)
    begin
      Zip::OutputStream.open(temp_file)
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        photo_files.each do |filename, file|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find it
          zipfile.add("images/"+filename, file)
        end
        text_files.each do |filename, file|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find its
          zipfile.add('text/'+filename, file)
        end
      end
      zip_data = File.read(temp_file.path)

      send_data(zip_data, type: 'application/zip', filename: zipfile_name)
    ensure
      # Close and delete the temp file
      temp_file.close
      temp_file.unlink
    end
  end

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
    h = {
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
