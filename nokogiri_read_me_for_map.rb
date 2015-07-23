require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'geocoder'

# html = open('https://github.com/stevekinney/pizza/blob/master/README.md')
html = open('https://github.com/cluhring/pizza/blob/master/README.md')

pizza  = Nokogiri::HTML(html)

states = pizza.css('div#readme h3')
cities = pizza.css('div#readme h4')
pizzerias = pizza.css('div#readme li')
pizza_hash =
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

# state: states.each { |state| puts state.text.chomp }
# city: cities.each { |city| puts city.text.chomp }

# pizzeria_name: pizzerias.each { |pizzeria| puts pizzeria.text.chomp }
# website: pizzerias.each { |pizzeria| puts pizzeria.child['href'].chomp }

# this finds pizzerias in given city:
# cities.each { |city| puts city.next_sibling.next_sibling.text.chomp }

# this lists pizzaria under cooresponding city:
# cities.each { |city| puts "#{city.text.chomp}: #{city.next_sibling.next_sibling.text.chomp}" }

pizzerias.each { |pizzeria| puts

  pizzeria_obj = {
    "type" => "Feature",
    "properties" => {
      "City" => nil,
      #"Pizzeria" => city.next_sibling.next_sibling.text.chomp,
      "Pizzeria" => pizzeria.text.chomp,
      "website" => pizzeria.child['href'].chomp,
      "marker-size" => "medium",
      "marker-color" => "ffff00",
      "marker-symbol" => "restaurant",
      # "stroke" => 224,
      # "stroke-opacity" => 0.5,
      # "stroke-width" => 8.0,
    },
    "geometry" => {
      "type" => "Point",
      "coordinates" => nil
    }
  }
pizza_hash["features"] << pizzeria_obj
}


# pizza_hash["properties"]["Pizzeria"] =

pizza_hash["features"].each do |x|
  cities.each do |city|
    pizzeria1 = city.next_sibling.next_sibling.text.downcase.delete("\n").gsub(/[^a-z]/, "")
    pizzeria2 = x["properties"]["Pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "")
    # binding.pry
    if pizzeria1.include?(pizzeria2)
      x["properties"]["City"] = city.text.chomp
      result = Geocoder.search(city.text)
      x["geometry"]["coordinates"] = [result.first.longitude, result.first.latitude]
      sleep 0.2
    end
  end
end

# pizza_hash["features"].map { |pizza_ob| pizza_ob["properties"]["Pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "") }.each do |pizzeria|
#   cities.each do |city|
#     city_pizzerias = city.next_sibling.next_sibling.text.downcase.delete("\n").gsub(/[^a-z]/, "")
#     if city_pizzerias.include?(pizzeria)
#       pizza_ob["properties"]["City"] = city.text
#       require 'pry' ; binding.pry
#     end
#   end
# end

# Geocoder.search("1 Twins Way, Minneapolis")

File.open("./pizza_map1.geojson","a+") do |f|
  f.write(pizza_hash.to_json)
end
