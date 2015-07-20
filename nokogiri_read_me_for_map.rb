require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

html = open('https://github.com/stevekinney/pizza/blob/master/README.md')
pizza  = Nokogiri::HTML(html)

states = pizza.css('div#readme h3')
cities = pizza.css('div#readme h4')
pizzerias = pizza.css('div#readme li')
pizza_arr = []

# state: states.each { |state| puts state.text.chomp }
# city: cities.each { |city| puts city.text.chomp }

# pizzeria_name:
# pizzerias.each { |pizzeria| puts pizzeria.text.chomp }

# website: pizzerias.each { |pizzeria| puts pizzeria.child['href'].chomp }

# this finds pizzarias in given city:
# cities.each { |city| puts city.next_sibling.next_sibling.text.chomp }
# cities.each { |city| puts city.next_sibling.next_sibling.text.chomp }

# this lists pizzaria under cooresponding city:
# cities.each { |city| puts "#{city.text.chomp}: #{city.next_sibling.next_sibling.text.chomp}" }

pizzerias.each { |pizzeria| puts
  pizzaeria_obj = {
    :type => "Feature",
    :geometry => {
      :type => "Point",
      :coordinates => [105.1667, 39.9333]
    },
    :properties => {
      :name => pizzeria.text,
      :website => pizzeria.child['href'],
      "marker-size" => "large",
      "marker-color" => "ffff00",
      "maker-symbol" => "restaurant",
      :stroke => 224,
      "stroke-opacity" => 0.5,
      "stroke-width" => 8.0,
    }
  }
pizza_arr << pizzaeria_obj
}
binding.pry

# redis_key =
# redis_value =  pizzaeria_obj

# end

File.open("./map1.json","w") do |f|
  f.write(pizza_arr.to_json)
end
