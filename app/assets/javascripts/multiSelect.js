var placesID = [];

function setMultiSelect(){
	$('#multi-select').multiSelect({
	  keepOrder: true,
	  selectableHeader: "<div class='custom-header'>Selectable places of interest</div>",
	  selectionHeader: "<div class='custom-header'>Selection places of interest</div>",
	  afterSelect: function(value){
	  	placesID.push(value[0]);
	  	sendPlacesForRoute(placesID);
	    //alert("Select value: "+placesID);
	  },
	  afterDeselect: function(value){
			var index = placesID.indexOf(value[0]);
	  	placesID.splice(index,1);
	  	sendPlacesForRoute(placesID);
	    //alert("Deselect value: "+placesID);
	  },
	  afterInit: function(){
	  	var selected = $('select#multi-select').val();
	  	sendPlacesForRoute(selected);
	  }
	});
}

function sendPlacesForRoute(placesID){
	$.ajax({
    url: "save_places",
    type: "post",
    data: "placesID=" + JSON.stringify(placesID),
    success: function(){
      //alert('Saved Successfully');
    },
    error:function(){
     console.log("error sending placesID");
    }
  });
}