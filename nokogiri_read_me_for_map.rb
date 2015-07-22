require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

html = open('https://github.com/stevekinney/pizza/blob/master/README.md')
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
      "name" => "Turing's Favorite Pizza Pies"
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
cities.each { |city| puts "#{city.text.chomp}: #{city.next_sibling.next_sibling.text.chomp}" }

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
      "coordinates" => [-105.1667, 39.9333]
    }
  }
pizza_hash["features"] << pizzeria_obj
}


# pizza_hash["properties"]["Pizzeria"] =

# pizza_hash["features"].each do |x|
#   cities.each do |city|
#     pizzeria1 = city.next_sibling.next_sibling.text.downcase.delete("\n").gsub(/[^a-z]/, "")
#     pizzeria2 = x["properties"]["Pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "")
#     # binding.pry
#     if pizzeria1.eql?(pizzeria2)
#       x["properties"]["City"] = city.text.chomp
#     end
#   end
# end

pizza_hash["features"].map { |pizza_ob| pizza_ob["properties"]["Pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "") }.each do |name|
  p_o = 0
  cities.each do |city|
    if city.next_sibling.next_sibling.text.downcase.delete("\n").gsub(/[^a-z]/, "").include?(name)
    pizza_hash["features"][p_o]["properties"]["City"] = city.text
    end
    # binding.pry
    p_o += 1
  end
end

File.open("./pizza_map.json","a+") do |f|
  f.write(pizza_hash.to_json)
end
