require "nokogiri"
require "pry"
require "json"
require "geocoder"
require "redcarpet"

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
readme = File.open("README.md")
html = markdown.render(readme.read)
readme.close

pizza  = Nokogiri::HTML(html)
cities = pizza.css('h4')
pizzerias = pizza.css('li')

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
      "city" => nil,
      "pizzeria" => pizzeria.first_element_child.text.chomp,
      "website" => pizzeria.child['href'].chomp,
      "address" => pizzeria.css('[href="#address"]').text.chomp,
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
    pizzeria2 = x["properties"]["pizzeria"].downcase.delete("\n").gsub(/[^a-z]/, "")
    if pizzeria1.include?(pizzeria2)
      x["properties"]["city"] = city.text.chomp
      geo_result = Geocoder.search(x["properties"]["address"] + ', ' + city.text)
      x["geometry"]["coordinates"] = [geo_result.first.longitude, geo_result.first.latitude]
      sleep 0.2
    end
  end
end

File.open("./pizza_map.geojson", "w+") do |f|
  f.write(pizzeria_hash.to_json)
end