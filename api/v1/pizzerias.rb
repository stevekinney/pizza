require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'json'

Encoding.default_external = 'UTF-8'

class API < Sinatra::Base
  configure do
    register Sinatra::Namespace
    register Sinatra::CrossOrigin
  end

  configure :development do
    register Sinatra::Reloader
  end

  enable :cross_origin

  namespace '/api' do
    namespace '/v1' do
      get '/pizzerias' do
        content_type :json
        geojson_data['features'].to_json
      end

      get '/pizzerias/:id' do
        content_type :json
        id = params[:id].to_i - 1
        json = geojson_data['features'][id].to_json
        if json == 'null'
          fail Sinatra::NotFound
        else
          json
        end
      end

      get '/properties/search' do
        content_type :json
        @query = params.keys
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
    @query.all? { |k| VALID_PROPERTY_PARAMS.include?(k) }
  end

  def return_search_results
    @pizzerias = geojson_data['features']
    locations = @pizzerias.select do |location|
      params.all? do |key, value|
        location['properties'][key].downcase == value.downcase
      end
    end
  end
end

VALID_PROPERTY_PARAMS = [
  'city',
  'pizzeria',
  'website',
  'address',
  'marker-size',
  'marker-color',
  'marker-symbol'
]
