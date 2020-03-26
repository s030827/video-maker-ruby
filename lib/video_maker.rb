require 'tty-prompt'
require 'algorithmia'

class VideoMaker
  include Text
  attr_accessor :data_structure

  def initialize
    @data_structure = {}

    ask_and_return_search_term
    ask_and_return_prefix
    fetch_content_from_wikipedia
  end

  private

  def ask_and_return_search_term
    @data_structure['searchTerm'] = TTY::Prompt.new.ask('Type a Wikipedia search term:', required: true)
  end

  def ask_and_return_prefix
    @data_structure['prefix'] = TTY::Prompt.new.select("Choose your destiny?", %w(Who\ is What\ is The\ history\ of), cycle: true)
  end

  def fetch_content_from_wikipedia
    @data_structure['source_content_original'] = get_content(@data_structure['searchTerm'])
    @data_structure['source_content_sanitize'] = content_into_sentences(@data_structure['source_content_original'])
  end
end