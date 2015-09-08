# d3 US Map of Steve Kinney's Favorite Pizza joints, complete with zoom & hover features.

![alt text](https://github.com/stevekinney/pizza/blob/master/examples/maps/d3_map/pizza_usa.png)

To view map, cd into d3_map and start a http-server: "http-server -p 8008 &"

The map will be visible at http://localhost:8008/

To stop this http-server, find the Server PID#: "lsof -i tcp:8008"

Then kill the server using the PID# "kill -9 INSERTPID#HERE"

To update map, create an new us.json file using the the below command in your terminal:

topojson -o us.json --id-property STATE_NAME --properties name=NAME --id-property SU_A3 --properties name=NAME --id-property pizzeria --properties name=NAME -- states.json countries.json ../../../pizza_map.geojson

Note - the above command requires TopoJSON, which requires Node.js. To install TopoJSON:
"npm install -g topojson"

Created by following the Mike Bostock ["Lets Make a Map Tutorial"](http://bost.ocks.org/mike/map/)
with assistance from QGIS concepts learned from ["Gretchen Peterson's GIS Tutorial."](https://github.com/PetersonGIS/Maptime-Boulder-Pub-Map) as well as other d3 sites, including but not limited to: 1) Label hover helpers - ["tooltips"](http://bl.ocks.org/Caged/6476579) & ["d3.tip"](https://github.com/Caged/d3-tip), 2) ["Zoom to Bounding Box II"](http://bl.ocks.org/mbostock/9656675), 3) topojson formatting helpers - ["Topojson Command Line Tools / GDAL"](https://github.com/mbostock/topojson/wiki/Command-Line-Reference) & ["Topojson point"](http://bl.ocks.org/mbostock/4408297)
