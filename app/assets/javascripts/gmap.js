var map;
var waypoints = [];
var draggedWaypoint;
var markers = [];
var placeMarkers = [];
var placeListener = [];

function initialize() {

  if (typeof(google) === 'undefined') {
    loadScript('initialize');
  } else {
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

    var polyOptions = {
      strokeColor: '#000000',
      strokeOpacity: 1.0,
      strokeWeight: 3
    };
    poly = new google.maps.Polyline(polyOptions);
    poly.setMap(map);
    poly.setPath(waypoints);

    google.maps.event.addListener(map, 'click', addLatLng);

    if (waypoints.length <= 0) {
      if (typeof(gon) === 'undefined') {
        console.log("gon undefined");
      }else if (typeof(gon.waypoints) !== 'undefined'){
        w = gon.waypoints;
        for (i = 0; i < w.length; i++) {
          latlng = new google.maps.LatLng(w[i].lat,w[i].lng);
          waypoints.push(latlng);
        }
      }else if (typeof(gon.places) !== 'undefined'){
        p = gon.places;
        for (i = 0; i < p.length; i++) {
          addPlaceMarker(p[i], i);
        }
      }
    }

    for (i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
      markers.splice(i,1);
    }
    for (i = 0; i < waypoints.length; i++) {
      addMarker(waypoints[i]);
    }
    centerMap(waypoints);
    poly.setPath(waypoints);
  }
}

function initializeMapView() {

  if (typeof(google) === 'undefined') {
    loadScript("initializeMapView");
  } else {
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

    console.log('testest', waypoints);
    if (waypoints.length <= 0) {
      if (typeof(gon) === 'undefined') {
        console.log("gon undefined");
      }else {
        w = gon.waypoints;
        for (i = 0; i < w.length; i++) {
          latlng = new google.maps.LatLng(w[i].lat,w[i].lng);
          waypoints.push(latlng);
        }
      }
    }
    centerMap(waypoints);
    removeListeners()

    var polyOptions = {
      strokeColor: '#000000',
      strokeOpacity: 1.0,
      strokeWeight: 3
    };
    poly = new google.maps.Polyline(polyOptions);
    poly.setMap(map);
    poly.setPath(waypoints);
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

function removeListeners() {
  if (typeof(map) !== 'undefined') {
    google.maps.event.clearListeners(map, 'click');
  }
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
    zIndex: markers.length
  });

  markers.push(marker);

  google.maps.event.addListener(marker,'dragstart', findDraggedWaypoint);
  google.maps.event.addListener(marker,'dragend', setPolylinePath);
  google.maps.event.addListener(marker,'rightclick', removeWaypoint);
}

function addPlaceMarker(place, i) {
  var infowindow = new google.maps.InfoWindow({
      content: place.title
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

  //placeMarkers.push(marker);
  placeMarkers.push(marker);

  google.maps.event.addListener(marker, 'dblclick', function() {
    infowindow.open(map,marker);
  });
  google.maps.event.addListener(marker, 'click', addPlaceToWaypoints);
}

function addPlaceToWaypoints(event) {
  draggedWaypoint = waypoints.length;
  setPolylinePath(event);

  for (var i = 0; i < placeMarkers.length; i++) {
    if (placeMarkers[i].position.lat() === event.latLng.lat() &&
        placeMarkers[i].position.lng() === event.latLng.lng()) {
      google.maps.event.addListener(placeMarkers[i], 'rightclick', deletePlaceFromWaypoints);
    }
  }
}

function deletePlaceFromWaypoints(event) {
  findDraggedWaypoint(event);
  setPolylinePath(null);

  for (var i = 0; i < placeMarkers.length; i++) {
    if (placeMarkers[i].position.lat() === event.latLng.lat() &&
        placeMarkers[i].position.lng() === event.latLng.lng()) {
      google.maps.event.clearListeners(placeMarkers[i], 'rightclick');
    }
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
    success: function(){
      //alert('Saved Successfully');
    },
    error:function(){
     console.log("error sending waypoint json");
    }
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
      findDraggedWaypoint(event);
      setPolylinePath(null);
      break;
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
    '&libraries=drawing' +
    //'&language=de' +
    '&callback=' + initialize;
  document.body.appendChild(script);
}
