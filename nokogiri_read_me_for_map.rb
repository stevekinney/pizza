require 'nokogiri'
require 'open-uri'
require 'pry'

html = open('https://github.com/stevekinney/pizza')
pizza  = Nokogiri::HTML(html)

states = pizza.css('h3').text
cities = pizza.css('h4').text
binding.pry
