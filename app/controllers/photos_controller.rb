class PhotosController < ApplicationController
  before_action :supported_languages

  def index
    @place = place
    @photos = @place.photos

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @photos }
      format.json { render json: @photos.map { |photo| photo.to_jq_upload } }
    end
  end

  def show
    @place = place
    @photo = @place.photos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  def new
    @place = place
    @photo = @place.photos.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  def edit
    @place = place
    @photo = @place.photos.find(params[:id])

    new_languages = @supported_languages.count - @photo.photo_translations.count
    new_languages.times { @photo.photo_translations.build }
  end

  def create
    @place = place
    @photo = @place.photos.build(photos_params)
    @photo.name = @photo.file.file.filename if @photo.name = ""
    @photo.save

    respond_to do |format|
      if @photo.save
        format.html {
          render :json => [@photo.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@photo.to_jq_upload]}, status: :created, location: [@place, @photo] }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @place = place
    @photo = @place.photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.html { redirect_to [@place, @photo], notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @place = place
    @photo = @place.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to place_photos_url }
      format.json { head :no_content }
    end
  end

  private

  def photos_params
    params.require(:photos).permit(
      :file,
      :name,
      photo_translations_attributes: [:id, :caption, :language]
    )
  end

  def photo_params
    params.require(:photo).permit(
      :file,
      :name,
      photo_translations_attributes: [:id, :caption, :language]
    )
  end

  def place
    Place.find(params[:place_id])
  end
end
