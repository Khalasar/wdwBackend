class PhotosController < ApplicationController
 # GET /documents
  # GET /documents.json
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @photos }
      format.json { render json: @photos.map{|photo| photo.to_jq_upload } }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /documents/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    p :photo_params => photo_params
    @photo = Photo.new(photo_params)
    @photo.save

    # respond_to do |format|
    #   if @document.save
    #     format.html { redirect_to @document, notice: 'Document was successfully created.' }
    #     format.json { render json: @document, status: :created, location: @document }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @document.errors, status: :unprocessable_entity }
    #   end
    # end

    respond_to do |format|
      if @photo.save
        format.html {
          render :json => [@photo.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.html { redirect_to @photo, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:file, :id)
  end
end
