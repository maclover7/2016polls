require 'sinatra'
require 'erb'

# The app!
class Pollster < Sinatra::Base
  get '/' do
    erb :home
  end
end
