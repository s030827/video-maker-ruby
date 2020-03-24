require 'tty-prompt'
require 'algorithmia'

class VideoMaker
  include Text
  attr_accessor :data_structure

  def initialize
    @data_structure = {}

    askAndReturnSearchTerm
    askAndReturnPrefix
    fetchContentFromWikipedia
  end

  private

  def askAndReturnSearchTerm
    @data_structure['searchTerm'] = TTY::Prompt.new.ask('Type a Wikipedia search term:', required: true)
  end

  def askAndReturnPrefix
    @data_structure['prefix'] = TTY::Prompt.new.select("Choose your destiny?", %w(Who\ is What\ is The\ history\ of), cycle: true)
  end

  def fetchContentFromWikipedia
    @data_structure['source_content_original'] = search(@data_structure['searchTerm'])
  end
end
