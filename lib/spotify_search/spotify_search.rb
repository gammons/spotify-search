# frozen_string_literal: true

require_relative "version"

require 'json'
require 'http'

module SpotifySearch
  class Error < StandardError; end

  class Spotify
    def initialize
      @client_id = ENV['SPOTIFY_CLIENT_ID']
      @client_secret = ENV['SPOTIFY_CLIENT_SECRET']
      @access_token = authorize
    end

    def search(artist_name, track_name)
      artist_name = filter_string(artist_name)

      req = HTTP.headers("Authorization": "Bearer #{@access_token}")
                .get('https://api.spotify.com/v1/search',
                    params: {
                      q: "artist:#{artist_name.downcase} track:#{track_name.downcase}", type: 'track'
                    })
      resp = JSON.parse(req.body.to_s)

      raise req.body unless req.code.to_s.start_with?('2')

      resp['tracks'] && resp['tracks']['items'] && resp['tracks']['items'][0]
    end

    def tracks(album_id); end

    def get_artist_id(artist_name)
      req = HTTP.headers("Authorization": "Bearer #{@access_token}")
                .get('https://api.spotify.com/v1/search',
                    params: { q: artist_name, type: 'artist' })
      raise req.body unless req.code.to_s.start_with?('2')

      @logger.debug("body is #{req.body}")
      resp = JSON.parse(req.body.to_s)

      spotify_artist_name = artist_name
      if resp['artists'].instance_of?(Array) && artist_name.split(' ').size > 1
        spotify_artist_name = FuzzyMatch.new(resp['artists'].map do |r|
                                              r['name']
                                            end, must_match_at_least_one_word: true).find(artist_name)
      end

      resp['artists']['items'].each do |result|
        puts "Artist = #{result['name']}"
        return result['id'] if result['name'].downcase == spotify_artist_name.downcase
      end
      nil
    end

    # https://api.spotify.com/v1/artists/1vCWHaC5f2uS3yhpwWbIA6/albums?offset=0&limit=2&include_groups=appears_on&market=ES
    def get_album(artist_id, album_name)
      return nil if artist_id.nil?

      url = "https://api.spotify.com/v1/artists/#{artist_id}/albums?offset=0&limit=50"
      req = HTTP.headers("Authorization": "Bearer #{@access_token}").get(url)
      raise req.body unless req.code.to_s.start_with?('2')

      @logger.debug("body is #{req.body}")
      resp = JSON.parse(req.body.to_s)
      spotify_album_name = FuzzyMatch.new(resp['items'].map do |r|
                                            r['name']
                                          end, must_match_at_least_one_word: true).find(album_name)
      resp['items'].each do |result|
        puts "Album = '#{result['name']}'"
        return result if result['name'].downcase == (spotify_album_name || '').downcase
      end
      nil
    end

    def authorize
      encoded = Base64.encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}").gsub(/\n/, '')
      resp = HTTP.headers("Authorization": "Basic #{encoded}")
                .post('https://accounts.spotify.com/api/token',
                      form: { grant_type: 'client_credentials' })
      raise resp.body unless resp.code.to_s.start_with?('2')

      json = JSON.parse(resp.body.to_s)
      json['access_token']
    end

    def filter_string(string)
      string
        .sub(/&amp;/, '&')
        .sub(/’/, '')
        .sub(/ EP/, '')
    end
  end
end