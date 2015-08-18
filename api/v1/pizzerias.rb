require 'sinatra'
require "sinatra/namespace"
require 'json'

namespace '/api' do
  namespace '/v1' do
    
    get '/pizzerias' do
      content_type :json
      geojson_data.to_json
    end

    get '/pizzerias/:id' do
      content_type :json
      id = params[:id].to_i - 1
      geojson_data['features'][id].to_json
    end

    get '/properties/search' do
      content_type :json
      @query = params.keys.first
      @pizzerias = geojson_data['features']

      valid_query? ? return_search_results.to_json : []
    end


  end
end

private
  def geojson_data
    JSON.parse(File.read('pizza_map.geojson'))
  end

  def valid_query?
    @pizzerias.any?{|pizzeria| pizzeria['properties'].has_key?(@query)}
  end
  
  def return_search_results
    @pizzerias.select{ |pizzeria| pizzeria['properties'][@query].downcase == params[@query].downcase}
  end
