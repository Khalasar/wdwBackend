require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  tests PhotosController

  let(:place) { FactoryGirl.create :place }

  describe 'index' do
    it 'shows index page' do
      place
      get :index

    end
  end


end
