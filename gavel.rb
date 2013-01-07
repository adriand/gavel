require 'sinatra'

get '/' do
  haml :index
end

get '/settings' do
  haml :settings
end
