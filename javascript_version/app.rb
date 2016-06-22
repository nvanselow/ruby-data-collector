require 'sinatra'
# require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/flash'

enable :sessions

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get '/' do
  erb :data_collector
end
