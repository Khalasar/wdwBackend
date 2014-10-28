class PagesController < ApplicationController
  def index
    @places = Place.all
    @routes = Route.all
  end
end
