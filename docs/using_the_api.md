# USING THE API

### UP & RUNNING
run `rackup`
This is a Rack API, so it will run locally on `http://localhost:9292`.
Attach the endpoint you want to that url to get back info.

### USING THE ENDPOINTS
currently there are three API endpoints

- INDEX: returns all locations `api/v1/pizzerias`
- SHOW: returns specific location by id `api/v1/pizzerias/:some_pizzeria_id`
- SEARCH: returns all properties for valid params `api/v1/properties/search?some_param=some query`

The first two are pretty self-explanatory.
The search endpoint is maybe the most useful at the moment.

Search will currently allow for any property param listed below:

- city
- pizzeria
- website
- address
- marker-size
- marker-color
- marker-symbol

EXAMPLE SEARCH QUERY: `api/v1/properties/search?pizzeria=lucky pie`

Search will dynamically take params allowing you to filter your results to the 'n'th degree.
- e.g. `api/v1/properties/search?city=oakland&pizzeria=nicks`

If you give it an invalid param, e.g `api/v1/properties/search?cats=grumpy`, or there are no results for the query, e.g, `api/v1/properties/search?city=middle of nowhere`, the API will return an empty array.


*** WHAT YOUR JSON WILL LOOK LIKE**

Given this search param: `http://localhost:4567/api/v1/properties/search?city=oakland`

```
[
  {
    type: "Feature",
    properties: {
      city: "Oakland",
      pizzeria: "Hi-Life",
      website: "http://www.hilifeoakland.com",
      address: "400 15th St",
      marker-size: "medium",
      marker-color: "ffff00",
      marker-symbol: "restaurant"
    },
    geometry: {
      type: "Point",
      coordinates: [
        -122.2694895,
        37.805068
      ]
    }
  },
  {
    type: "Feature",
    properties: {
      city: "Oakland",
      pizzeria: "Zachary's",
      website: "http://zacharys.com/locations/oakland",
      address: "5801 College Ave.",
      marker-size: "medium",
      marker-color: "ffff00",
      marker-symbol: "restaurant"
    },
    geometry: {
      type: "Point",
      coordinates: [
        -122.2521705,
        37.8462724
      ]
    }
  },
  {
    type: "Feature",
    properties: {
      city: "Oakland",
      pizzeria: "Nicks",
      website: "http://oaklandstylepizza.com/",
      address: "6211 Shattuck Ave.",
      marker-size: "medium",
      marker-color: "ffff00",
      marker-symbol: "restaurant"
    },
    geometry: {
    type: "Point",
    coordinates: [
      -122.2657076,
      37.8482871
      ]
    }
  }
]

```

### CONTRIBUTING TO THE API
Feel free to contribute and submit a PR.

**SOME CURRENTLY NEEDED / DESIRED FEATURES:**

- Some logic to make the API deployable 
- A reliable 'near-me' endpoint `api/v1/properties/near-me`
  - for a user's lat/long return all locations nearby.

We are also playing with the idea of building a separate Go API.