file = File.read(Rails.root + 'app/assets/route1.json')

routeJson = JSON.parse(file)

waypoints = routeJson['array']['dict']

points = []
waypoints.each do |w|
	points << w['string'].tr('{}', '').split(',')
end

route = Route.find(4)

points.each do |p|
	route.waypoints.build(lat: p[0], lng: p[1])
end

route.save