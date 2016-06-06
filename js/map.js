!(function () {
  
  var mapData;

  function jsonSuccess (data) {
    mapData = JSON.parse(data).features;
    var map = Map(mapVars);
    var setMarker = Marker(map);

    for (var i = 0; i < mapData.length; i++) {
      setMarker(mapData[i]); 
      console.log(mapData[i]); 
    }
  };
  
  var mapVars = { // Play with different map attributes here //  
    style : [
      {
        stylers: [
          { hue: "#00ffe6" },
          { saturation: -20 }
        ]
      },{
        featureType: "road",
        elementType: "geometry",
        stylers: [
          { lightness: 100 },
          { visibility: "simplified" }
        ]
      },{
        featureType: "road",
        elementType: "labels",
        stylers: [
          { visibility: "off" }
        ]
      }
    ],
    canvas : document.getElementById("map-canvas"),
    centerCoord : { // Nice center point over North America //
    lat: 39.00, 
    lng: -100.00 
    },
    zoomLevel: 4 //Works well on desktops, may need to adjust/script for mobile friendly
  };

  var Map = function (mapVars) {
    var mapCenterPoint = new google.maps.LatLng(
      mapVars.centerCoord.lat, 
      mapVars.centerCoord.lng
    );

    var mapOptions = {
      center: mapCenterPoint,
      zoom: mapVars.zoomLevel,
    }; 
    
    var map = new google.maps.Map(mapVars.canvas, mapOptions);
    map.setOptions({styles: mapVars.style});
    
    return map;
  };


  var Marker = function(map) {

    setMarker = function (entry) {
      var newMarker = marker(entry);
      addMarkerListener(newMarker, infoWindow(entry));
      newMarker.setMap(map);
    };

    addMarkerListener = function (marker, infoWindow) {
        google.maps.event.addListener(marker, 'click', function() {
          infoWindow.open(map,marker);
        });
    };

    marker = function (entry) {
      return new google.maps.Marker({
        position: latLong(entry),
        map: map,
        title: entry.properties.pizzeria,
        animation: google.maps.Animation.DROP
      });
    };

    latLong = function (entry) {
      var coords = entry.geometry.coordinates;
      return new google.maps.LatLng(coords[1], coords[0]); 
    };

    infoWindow = function (entry) {
      var infoWindowContent = contentHtml(entry);
      return new google.maps.InfoWindow({content: infoWindowContent});
    };

    contentHtml = function(entry) {
      var props = entry.properties;
      return '<div id="content">'+
        props.pizzeria + 
        '<br />' +
        props.address +
        '<br />' +
        props.city + 
        '<br />' +
        '<a href=' + props.website + '>' + props.website + '</a>'
      '</div>';
    };
    return setMarker;
  };



  window.onload = function () {
  psQuery.ajax({url: 'https://raw.githubusercontent.com/ETNOL/pizza/master/pizza_map.geojson', success: jsonSuccess})
  }; 


})();

