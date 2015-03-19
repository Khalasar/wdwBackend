require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  tests PhotosController

  let(:place) { FactoryGirl.create :place }

  describe 'index' do
    it 'shows index page' do
      get :index, place_id: place.id
      assert_response :success
    end
  end
end
