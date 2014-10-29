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
    supported_languages.count.times { @place.place_translations.build }
  end

  # GET /places/1/edit
  def edit
    new_languages = supported_languages.count - @place.place_translations.count
    new_languages.times { @place.place_translations.build }
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
      :description,
      :lat,
      :lng,
      :english_text,
      :german_text,
      place_translations_attributes: [:id, :title, :subtitle, :language])
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

end
