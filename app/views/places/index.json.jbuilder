json.array!(@places) do |place|
  json.extract! place, :id, :identifier, :description, :lat, :lng
  json.url place_url(place, format: :json)
end
