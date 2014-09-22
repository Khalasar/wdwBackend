var placesID = [];
function setMultiSelect(){
  $('#multi-select').multiSelect({
    keepOrder: true,
    selectableHeader: "<div class='custom-header'>Selectable places of interest</div>",
    selectionHeader: "<div class='custom-header'>Selection places of interest</div>",
    afterSelect: function(value){
      placesID.push(value[0]);
      if (placesID.length > 0) {
        sendPlacesForRoute(placesID);
      };
      //alert("Select value: "+placesID);
    },
    afterDeselect: function(value){
      var index = placesID.indexOf(value[0]);
      removePlaceMarker(placesID[index]);
      placesID.splice(index,1);
      //sendPlacesForRoute(placesID);
      //alert("Deselect value: "+placesID);
    },
    afterInit: function(){
      var selected = $('select#multi-select').val();
      if (selected) {
        placesID = selected;
        //sendPlacesForRoute(placesID);
      };
    }
  });
}

function sendPlacesForRoute(placesID){
  $.ajax({
    url: "save_places",
    type: "post",
    data: "placesID=" + JSON.stringify(placesID),
    async: false
  })
  .done(function(result) {
    addPlaceMarker(result);
    console.log('success');
  })
  .fail(function() {
    console.log('error send places for route');
  });
}

function sendPlaces(placesID){
  $.ajax({
    url: "save_places",
    type: "post",
    data: "placesID=" + JSON.stringify(placesID),
    async: false
  })
  .done(function() {
    console.log('success');
  })
  .fail(function( jqXHR, textStatus, errorThrown) {
    console.log('error send places');
  });
}