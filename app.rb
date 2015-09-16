require 'sinatra'

# The app!
class Pollster < Sinatra::Base
  get '/' do
    'hello'
  end
end
