require 'erb'
require 'httparty'
require 'json'
require 'sinatra'

# The app!
class Pollster < Sinatra::Base
  # Fetch data from the Huffington Post
  class HuffAPI
    def self.fetch_huff_data(party)
      huff_chart_url = 'http://elections.huffingtonpost.com/pollster/api/charts'
      url = huff_chart_url + "/2016-national-#{party}-primary"
      data = ::HTTParty.get(url).body
      ::JSON.load(data)
    end

    #-----

    def self.leader(party)
      data = fetch_huff_data(party)
      data['estimates'].first['choice']
    end

    def self.standings(party)
      huff_data = fetch_huff_data(party)
      data = {}
      huff_data['estimates'].collect do |candidate|
        data[candidate['choice']] = candidate['value']
      end
      data
    end
  end

  get '/' do
    @democratic_leader = HuffAPI.leader('democratic')
    @democratic_standings = HuffAPI.standings('democratic')
    @republican_leader = HuffAPI.leader('gop')
    @republican_standings = HuffAPI.standings('gop')
    erb :home
  end
end
