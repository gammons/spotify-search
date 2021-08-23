# frozen_string_literal: true

RSpec.describe SpotifySearch do
  let(:spotify) { SpotifySearch::Spotify.new }
  let(:tests) do
    [
      {
        artist: 'Log',
        song: 'Just because you can',
        album: 'Auto Fire Life'
      },
      {
        artist: 'The World/Inferno Friendship Society',
        song: 'Jerusalem Boys',
        album: 'Red-Eyed Soul'
      },
      {
        artist: 'Sema 4',
        song: 'Up Down Around',
        album: 'In Memory Of...'
      },
      {
        artist: 'The Buzzcocks',
        song: 'What do I get?',
        album: 'Singles Going Steady'
      },
      {
        artist: 'Sparks',
        song: 'At Home, At Work, At Play',
        album: 'Propaganda'
      }
    ]
  end

  it 'has a version number' do
    expect(SpotifySearch::VERSION).not_to be nil
  end

  it 'runs' do
    results = spotify.search('Ween', 'Sarah')

    expect(results['album']['name']).to eq('Pure Guava')
  end

  it 'ignores the word "the" in artist name' do
    results = spotify.search('The World/Inferno Friendship Society', 'Jerusalem Boys')
    expect(results['album']['name']).to eq('Red-Eyed Soul')
  end

  it 'finds a bunch of obscure things' do
    tests.each do |test|
      results = spotify.search(test[:artist], test[:song])
      expect(results).to_not be_nil
      expect(results['album']['name']).to eq(test[:album])
    end
  end
end
