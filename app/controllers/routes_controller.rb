require 'json'

class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy,
                                   :map, :save, :save_places]
  before_action :supported_languages

  def save
    p waypoints: params[:waypoints]
    waypoints = JSON.parse params[:waypoints]
    @route.waypoints.destroy_all
    waypoints.each do |waypoint|
      @route.waypoints.build(lat: waypoint['lat'], lng: waypoint['lng'])
    end
    @route.save

    render json: @route.waypoints
  end

  def save_places
    temp_place = nil
    placesID = JSON.parse params[:placesID]
    @route.places = []
    @route.place_order = placesID.join(',')
    placesID.each do |id|
      @route.places << Place.find(id)
      temp_place = Place.find(id)
    end
    @route.save

    render json: temp_place
  end

  def map
  end

  def index
    @routes = Route.all

    respond_to do |format|
      format.html
      format.json { render json: @routes }
    end
  end

  def show
    gon.waypoints = @route.waypoints
    gon.route_places = @route.places

    respond_to do |format|
      format.html
      format.json { render json: @route }
    end
  end

  def new
    @route = Route.new
    supported_languages.count.times { @route.route_translations.build }
  end

  def edit
    gon.waypoints = @route.waypoints
    gon.route_places = @route.places

    new_languages = @supported_languages.count - @route.route_translations.count
    new_languages.times { @route.route_translations.build }
  end

  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html do
          redirect_to route_map_path(@route),
                      notice: 'Route was successfully created.'
        end
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html do
          redirect_to @route, notice: 'Route was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json do
          render json: @route.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @route.destroy
    respond_to do |format|
      format.html do
        redirect_to routes_url, notice: 'Route was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_route
    @route = Route.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def route_params
    params.require(:route).permit(
      route_translations_attributes: [:id, :title, :subtitle, :language,
                                      :country, :city, :region, :route_type,
                                      :description]
    )
  end
end
