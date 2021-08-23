# frozen_string_literal: true

RSpec.describe SpotifySearch do
  let(:spotify) { SpotifySearch::Spotify.new }

  it 'has a version number' do
    expect(SpotifySearch::VERSION).not_to be nil
  end

  it 'runs' do
    results = spotify.search('Ween', 'Sarah')

    expect(results['album']['name']).to eq('Pure Guava')
  end

  it 'finds this' do
    results = spotify.search('Gonzo', 'Dies (excerpt)')
    expect(results).to_not be_nil
    byebug
    sleep 0
  end
end
