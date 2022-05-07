# frozen_string_literal: true

RSpec.describe SpotifySearch do
  let(:spotify) { SpotifySearch::Searcher.new }
  let(:track_searches) do
    [
      {
        artist: 'Log',
        song: 'Just because you can',
        album: 'Twenty One and Hungover'
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
      },
      {
        artist: 'PETR SKOUMAL',
        song: 'Jeden můj známej',
        album: '...Se Nezblázni, Poločas Rozpadu'
      },
      {
        artist: 'BRIAN ENO & DAVID BYRNE',
        song: 'America Is Waiting',
        album: 'My Life in the Bush of Ghosts'
      },
      {
        artist: 'EDUARDO MATEO',
        song: 'María',
        album: 'El Tartamudo'
      },
      {
        artist: 'The Real Kids',
        song: 'Common at Noon',
        album: 'Better Be Good'
      },
      {
        artist: 'Austra',
        song: 'Mountain Baby (feat. Cecile Believe)',
        album: 'HiRUDiN'
      },
    ]
  end

  it 'has a version number' do
    expect(SpotifySearch::VERSION).not_to be nil
  end

  describe '#track_search' do
    it 'runs' do
      results = spotify.track_search('Ween', 'Sarah')

      expect(results['album']['name']).to eq('Pure Guava')
    end

    it 'ignores the word "the" in artist name' do
      results = spotify.track_search('The World/Inferno Friendship Society', 'Jerusalem Boys')
      expect(results['album']['name']).to eq('Red-Eyed Soul')
    end

    it 'finds a bunch of obscure things' do
      track_searches.each do |test|
        results = spotify.track_search(test[:artist], test[:song])
        expect(results).to_not be_nil
        expect(results['album']['name']).to eq(test[:album])
      end
    end
  end

  describe '#album_search' do
    it 'runs' do
      results = spotify.album_search('Ween', 'Pure Guava')

      expect(results['name']).to eq('Pure Guava')
      expect(results['id']).to eq('4RaWphn8iwAU3i6dXVhchX')
    end

    it 'filters out single apostrophe' do
      results = spotify.album_search('Pusha T', 'It’s Almost Dry')

      expect(results).to_not be_nil
      expect(results['name']).to eq("It's Almost Dry")
      expect(results['id']).to eq('6o38CdD7CUlZDCFhjZYLDH')
    end
  end
end
