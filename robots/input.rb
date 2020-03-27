module Input
  def ask_terms
    ask_and_return_search_term
    ask_and_return_prefix
  end

  def ask_and_return_search_term
    @data_structure['searchTerm'] = TTY::Prompt.new.ask('Type a Wikipedia search term:', required: true)
  end

  def ask_and_return_prefix
    @data_structure['prefix'] = TTY::Prompt.new.select('Choose your destiny?', %w(Who\ is What\ is The\ history\ of), cycle: true)
  end
end
