module RoutesHelper
	def places_selected
		if @route.places
			@route.places.map do |place|
				place.id
			end
		else
			""
		end

	end

	def all_places
		Place.all.collect{ |p| [p.identifier, p.id] }
	end
end
