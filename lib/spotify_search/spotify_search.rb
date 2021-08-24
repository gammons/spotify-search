# frozen_string_literal: true

require_relative 'version'

require 'json'
require 'base64'
require 'http'
require 'i18n'

module SpotifySearch
  class Error < StandardError; end

  # Searcher class searches for spotify information, with some specific helpers for
  # finding obscure titles.
  class Searcher
    def initialize(client_id = ENV['SPOTIFY_CLIENT_ID'], client_secret = ENV['SPOTIFY_CLIENT_SECRET'])
      @client_id = client_id
      @client_secret = client_secret
      @access_token = authorize
    end

    # Given an artist name and a track name, find the information that spotify has on the
    def track_search(artist_name, track_name)
      artist_name = filter_artist_string(artist_name)
      track_name = filter_string(track_name)

      req = HTTP.headers("Authorization": "Bearer #{@access_token}")
                .get('https://api.spotify.com/v1/search',
                     params: {
                       q: "artist:#{artist_name.downcase} track:#{track_name.downcase}", type: 'track'
                     })
      resp = JSON.parse(req.body.to_s)

      raise req.body unless req.code.to_s.start_with?('2')

      resp['tracks'] && resp['tracks']['items'] && resp['tracks']['items'][0]
    end

    def album_search(artist_name, album_name)
      artist_name = filter_artist_string(artist_name)
      album_name = filter_string(album_name)

      req = HTTP.headers("Authorization": "Bearer #{@access_token}")
                .get('https://api.spotify.com/v1/search',
                     params: {
                       q: "artist:#{artist_name.downcase} album:#{album_name.downcase}", type: 'album'
                     })
      resp = JSON.parse(req.body.to_s)

      raise req.body unless req.code.to_s.start_with?('2')

      resp['albums'] && resp['albums']['items'] && resp['albums']['items'][0]
    end

    private

    def authorize
      encoded = Base64.encode64("#{@client_id}:#{@client_secret}").gsub(/\n/, '')
      resp = HTTP.headers("Authorization": "Basic #{encoded}")
                 .post('https://accounts.spotify.com/api/token',
                       form: { grant_type: 'client_credentials' })
      raise resp.body unless resp.code.to_s.start_with?('2')

      json = JSON.parse(resp.body.to_s)
      json['access_token']
    end

    def filter_artist_string(string)
      filter_string(string).sub(/the /i, '')
    end

    def filter_string(string)
      I18n::Backend::Transliterator.get.transliterate(string)
                                   .sub(/&amp;/, '&')
                                   .sub(/’/, '')
                                   .sub(/'/, '')
                                   .sub(/ EP/, '')
                                   .gsub(/\(.*\)/, '').strip
    end
  end
end
