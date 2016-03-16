require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'warden'

require 'roar/decorator'
require 'roar/json'
require 'roar/json/hal'

require 'kaminari/sinatra'

require 'rack/contrib'

mime_type :json, "application/json"

set :root, File.dirname(__FILE__)
set :static, true

class App < Sinatra::Base

end
require './models/base_representer'
require './models/tag'
require './models/item'
require './models/list'
require './helpers/application_helper'
require './routes/application_route'
Dir.glob('./{helpers,routes,models}/*.rb').each { |file| require file }
