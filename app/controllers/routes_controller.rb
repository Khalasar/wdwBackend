require 'json'

class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy, :map, :save]

  def save
    waypoints = JSON.parse params[:waypoints]
    @route.waypoints.destroy_all
    waypoints.each do |waypoint|
      @route.waypoints.build(lat: waypoint["lat"], lng: waypoint["lng"])
    end
    @route.save
    render :nothing => true
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
    respond_to do |format|
      format.html
      format.json { render json: @route }
    end
  end

  def new
    @route = Route.new
  end

  def edit
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
        format.json { render json: @route.errors, status: :unprocessable_entity }
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
      :title,
      :subtitle
    )
  end
end
