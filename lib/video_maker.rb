require 'tty-prompt'

class VideoMaker
  attr_accessor :data_structure

  def initialize
    @data_structure = {}
    @data_structure['searchTerm'] = askAndReturnSearchTerm
    @data_structure['prefix']     = askAndReturnPrefix
  end

  private

  def askAndReturnSearchTerm
    TTY::Prompt.new.ask('Type a Wikipedia search term:', required: true)
  end

  def askAndReturnPrefix
    TTY::Prompt.new.select("Choose your destiny?", %w(Who\ is What\ is The\ history\ of), cycle: true)
  end
end
