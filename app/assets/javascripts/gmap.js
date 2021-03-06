var map;
var waypoints = [];
var draggedWaypoint;
var markers = [];
var placeMarkers = [];
var places = [];
var eventListener = [];
var notOnShow;

function removeListener() {
  /*for (var i = 0; i < eventListener.length; i++) {

    //google.maps.event.removeListener(eventListener[i]);
  };*/
  if (typeof(map) !== 'undefined' && eventListener.length > 0) {
    google.maps.event.clearListeners(map, 'click');
  }
  notOnShow = false;
}

function loadNotOnShow(b) {
  notOnShow = true;
}

function initialize() {

  if (typeof(google) === 'undefined') {
    loadScript('initialize');
  } else {
    initializeMap();
    initializePolyline();

    if (!waypointsAvailable() && typeof(gon) !== 'undefined') {

      loadWaypointsFromCtrl();
    }

    loadPlaceMarker();
    initSearchBox();
    removeWaypointMarkers();

    if (notOnShow) {
      eventListener.push(google.maps.event.addListener(map, 'click', addLatLng));
      addWaypointMarkers();
    }

    centerMap(waypoints);
    poly.setPath(waypoints);
  }
}

function initSearchBox() {

  var input = document.getElementById('pac-input');
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

  var searchBox = new google.maps.places.SearchBox(input);

  google.maps.event.addListener(searchBox, 'places_changed', function() {
    var places = searchBox.getPlaces();
    var bounds = new google.maps.LatLngBounds();
    for (var i = 0, place; place = places[i]; i++) {
      bounds.extend(place.geometry.location);
      map.panTo(place.geometry.location);
    }
  });

  google.maps.event.addListener(map, 'bounds_changed', function() {
    var bounds = map.getBounds();
    searchBox.setBounds(bounds);
  });
}

function initializeMap(listener) {
  var mapOptions = {
    center: new google.maps.LatLng(51.665041, 7.631431),
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.NORMAL,
    panControl: true,
    scaleControl: false,
    streetViewControl: true,
    overviewMapControl: true
  };
  // initializing map
  map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);
}

function initializePolyline() {
  var polyOptions = {
    strokeColor: '#000000',
    strokeOpacity: 1.0,
    strokeWeight: 3
  };
  poly = new google.maps.Polyline(polyOptions);
  poly.setMap(map);
}

function waypointsAvailable(){
  return waypoints.length > 0;
}

function loadWaypointsFromCtrl() {
  if (typeof(gon.waypoints) !== 'undefined'){
    w = gon.waypoints;
    for (i = 0; i < w.length; i++) {
      latlng = new google.maps.LatLng(w[i].lat,w[i].lng);
      waypoints.push(latlng);
    }
  }
}

function removeWaypointMarkers() {
  for (i = 0; i < markers.length; i++) {
    markers[i].setMap(null);
    markers.splice(i,1);
  }
}

function addWaypointMarkers() {
  for (i = 0; i < waypoints.length; i++) {
    addMarker(waypoints[i]);
  }
}

function centerMap (wayp) {
  var bound = new google.maps.LatLngBounds();

  for (i = 0; i < wayp.length; i++) {
    bound.extend( new google.maps.LatLng(wayp[i].lat(), wayp[i].lng()) );
  }

  var center;
  if (bound.isEmpty()) {
    center = new google.maps.LatLng(51.665041, 7.631431);
  }else {
    center = bound.getCenter();
    map.fitBounds(bound);
  }
  map.setCenter(center);
}

function addLatLng(event) {
  draggedWaypoint = waypoints.length;
  setPolylinePath(event);

  addMarker(event.latLng);
}

function addMarker(latLng) {
  // Add a new marker at the new plotted point on the polyline.
  var marker = new google.maps.Marker({
    position: latLng,
    draggable:true,
    animation: google.maps.Animation.DROP,
    map: map,
    zIndex: markers.length,
    icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
  });

  if(markers.length == 0){
    marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png')
  }else{
    updateLastWaypoint();
  }
  markers.push(marker);

  google.maps.event.addListener(marker,'dragstart', findDraggedWaypoint);
  google.maps.event.addListener(marker,'dragend', setPolylinePath);
  google.maps.event.addListener(marker,'rightclick', removeWaypoint);
}

function loadPlaceMarker() {
  placeMarkers = [];
  if (typeof(gon) !== 'undefined' && typeof(gon.route_places) !== 'undefined') {
    route_places = gon.route_places;
    for (i = 0; i < route_places.length; i++) {
      addPlaceMarker(route_places[i]);
    }
  }else {
    for (i = 0; i < places.length; i++) {
      addPlaceMarker(places[i]);
    }
  }
}

function addPlaceMarker(place) {
  var infowindow = new google.maps.InfoWindow({
      content:  place.title
  });

  // Add a new marker at the new plotted point on the polyline.
  var image = '/images/marker-blue.png';
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(place.lat, place.lng),
    animation: google.maps.Animation.DROP,
    map: map,
    //zIndex: markers.length,
    icon: image,
    title: "sdsds"
  });

  var markerObject = {id:place.id, marker:marker};
  placeMarkers.push(markerObject);
  places.push(place);

  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  });
}

function addPlaceMarkers(places) {
  //removePlaceMarker
  for (var i = 0; i < places.length; i++) {
    addPlaceMarker(places[i]);
  };
}

function removePlaceMarker(placeID) {
  for (var i = 0; i < placeMarkers.length; i++) {
    if (placeMarkers[i].id == placeID) {
      placeMarkers[i].marker.setMap(null);
      placeMarkers.splice(i,1);
      break;
    };
  }
}

function setPolylinePath(event) {
  if (event) {
    waypoints.splice(draggedWaypoint, 1, event.latLng);
  }else {
    waypoints.splice(draggedWaypoint, 1);
  }
  poly.setPath(waypoints);

  //sendWaypointsJSON();
}

function sendWaypointsJSON() {
  var waypointsJson = [];
  for (i = 0; i < waypoints.length; i++) {
    waypointsJson.push({
      lat: waypoints[i].lat(),
      lng: waypoints[i].lng()
    });
  }

  $.ajax({
    url: "save",
    type: "post",
    data: "waypoints=" + JSON.stringify(waypointsJson),
    async: false
  }).done(function() {
    console.log('success');
  })
  .fail(function( jqXHR, textStatus, errorThrown) {
    console.log('error waypoints');
  });
}

function findDraggedWaypoint(event) {
  for (i = waypoints.length - 1; i >= 0; i--) {
    if (waypoints[i] == event.latLng) {
      draggedWaypoint = i;
      break;
    }
  }
}

function removeWaypoint(event) {
  for (i = 0; i < markers.length; i++) {
    if (markers[i].position == event.latLng) {
      // remove marker from map
      markers[i].setMap(null);
      markers.splice(i,1);
      findDraggedWaypoint(event);
      setPolylinePath(null);
      break;
    }
  }
  updateWaypointIcons();
}

function updateLastWaypoint() {
  if(markers.length > 1){
    markers[markers.length - 1]
      .setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png')
  }
}

function updateWaypointIcons() {
  console.log(markers.length);
  for (var i = 0; i < markers.length; i++) {
    if (i == 0) {
      markers[i].setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png')
    }else if (i == markers.length - 1) {
      markers[i].setIcon('http://maps.google.com/mapfiles/ms/icons/blue-dot.png')
    }
  }
}

function loadScript(initialize) {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?' +
    //'&v=3.14'+
    '&sensor=false'+
    '&key=AIzaSyDVy2E1b4Sm3jwkMVmfNruDfQ_PDVylGlE'+
    '&libraries=drawing,places' +
    //'&language=de' +
    '&callback=' + initialize;
  document.body.appendChild(script);
}
