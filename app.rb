require 'erb'
require 'httparty'
require 'json'
require 'sinatra'

# The app!
class Pollster < Sinatra::Base
  # Fetch data from the Huffington Post
  class HuffAPI
    def self.fetch_huff_data(scope, party, election_type)
      huff_chart_url = 'http://elections.huffingtonpost.com/pollster/api/charts'
      url = huff_chart_url + "/2016-#{scope}-#{party}-#{election_type}"
      data = ::HTTParty.get(url).body
      ::JSON.load(data)
    end

    #-----

    def self.leader(scope, party, election_type)
      data = fetch_huff_data(scope, party, election_type)
      data['estimates'].first['choice']
    end

    def self.standings(scope, party, election_type)
      huff_data = fetch_huff_data(scope, party, election_type)
      data = {}
      huff_data['estimates'].collect do |candidate|
        data[candidate['choice']] = candidate['value']
      end
      data
    end
  end

  get '/' do
    @heading = "National"
    @democratic_leader = HuffAPI.leader('national', 'democratic', 'primary')
    @democratic_standings = HuffAPI.standings('national', 'democratic', 'primary')
    @republican_leader = HuffAPI.leader('national', 'gop', 'primary')
    @republican_standings = HuffAPI.standings('national', 'gop', 'primary')
    erb :home
  end

  get '/:state' do
    case params[:state]
    when 'ia', 'iowa'
      @heading = "Iowa"
      @democratic_leader = HuffAPI.leader('iowa-presidential', 'democratic', 'primary')
      @democratic_standings = HuffAPI.standings('iowa-presidential', 'democratic', 'primary')
      @republican_leader = HuffAPI.leader('iowa-presidential', 'republican', 'primary')
      @republican_standings = HuffAPI.standings('iowa-presidential', 'republican', 'primary')
    when 'nh', 'new-hampshire'
      @heading = "New Hampshire"
      @democratic_leader = HuffAPI.leader('new-hampshire-presidential', 'democratic', 'caucus')
      @democratic_standings = HuffAPI.standings('new-hampshire-presidential', 'democratic', 'caucus')
      @republican_leader = HuffAPI.leader('new-hampshire-presidential', 'republican', 'caucus')
      @republican_standings = HuffAPI.standings('new-hampshire-presidential', 'republican', 'caucus')
    end
    erb :home
  end
end
