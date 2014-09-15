require 'json'

class RoutesController < ApplicationController
  def save
    waypoints = JSON.parse params[:waypoints]
    p :test => waypoints
    render :nothing => true
  end
end
