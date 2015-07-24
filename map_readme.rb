require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'geocoder'

html = open('https://github.com/stevekinney/pizza/blob/master/README.md')

pizza  = Nokogiri::HTML(html)
cities = pizza.css('div#readme h4')
pizzerias = pizza.css('div#readme li')

pizzeria_hash =
{
  "type" => "FeatureCollection",
  "crs" => {
    "type" => "name",
    "properties" => {
      "name" => "urn:ogc:def:crs:OGC:1.3:CRS84"
    }
  },
  "features" => [
  ]
}

pizzerias.each { |pizzeria|
  pizzeria_obj = {
    "type" => "Feature",
    "properties" => {
      "City" => nil,
      "Pizzeria" => pizzeria.text.chomp,
      "website" => pizzeria.child['href'].chomp,
      "marker-size" => "medium",
      "marker-color" => "ffff00",
      "marker-symbol" => "restaurant"
    },
    "geometry" => {
      "type" => "Point",
      "coordinates" => nil
    }
  }
pizzeria_hash["features"] << pizzeria_obj
}

pizzeria_hash["features"].each do |x|
  cities.each do |city|
    pizzeria1 = city.next_sibling.next_sibling.text.downcase.delete("\n").gsub(/[^a-z]/, "")
    pizzeria2 = x["properties"]["Pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "")
    if pizzeria1.include?(pizzeria2)
      x["properties"]["City"] = city.text.chomp
      geo_result = Geocoder.search(city.text)
      x["geometry"]["coordinates"] = [geo_result.first.longitude + (rand(1..100) * 10**-3), geo_result.first.latitude + (rand(1..100) * 10**-3)]
      sleep 0.2
    end
  end
end

File.open("./pizza_map.geojson","w+") do |f|
  f.write(pizzeria_hash.to_json)
end
