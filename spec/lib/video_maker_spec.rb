require File.expand_path('lib/video_maker')
require 'tty-prompt'
require 'byebug'

describe VideoMaker do
  describe "Capture search 'Banana'" do

    subject(:movie) { VideoMaker.new }

    it "Initialize'" do
      expect(movie.data_structure['search_term']).to eq('Banana')
      expect(movie.data_structure['prefix']).to eq('What is')
    end
  end
end