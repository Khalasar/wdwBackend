var map;
var waypoints = [];
var draggedWaypoint;
var markers = [];

function initialize() {

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

  /*// initialize marker
  var marker = new google.maps.Marker({
    position: map.getCenter(),
    map: map,
    title: 'Click to zoom'
  });*/

  var polyOptions = {
      strokeColor: '#000000',
      strokeOpacity: 1.0,
      strokeWeight: 3
  };
  poly = new google.maps.Polyline(polyOptions);
  poly.setMap(map);

  // Add a listener for the click event
  google.maps.event.addListener(map, 'click', addLatLng);
}

function addLatLng(event) {
  draggedWaypoint = waypoints.length;
  setPolylinePath(event);

  // Add a new marker at the new plotted point on the polyline.
  var marker = new google.maps.Marker({
    position: event.latLng,
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

function setPolylinePath(event) {
  if (event) {
    waypoints.splice(draggedWaypoint, 1, event.latLng);
  }else {
    waypoints.splice(draggedWaypoint, 1);
  }
  poly.setPath(waypoints);

  sendWaypointsJSON();
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
  console.log(waypointsJson);
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

function loadScript() {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?' +
    //'&v=3.14'+
    '&sensor=false'+
    '&key=AIzaSyDVy2E1b4Sm3jwkMVmfNruDfQ_PDVylGlE'+
    '&libraries=drawing'+
    //'&language=de' +
    '&callback=initialize';
  document.body.appendChild(script);
}
