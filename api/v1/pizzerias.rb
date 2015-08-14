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

  end
end

private
  def geojson_data
    file = File.read('pizza_map.geojson')
    JSON.parse(file)
  end
