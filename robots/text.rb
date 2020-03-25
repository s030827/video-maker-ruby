module Text
  def client_algorithmia
    Algorithmia.client(ENV['KEY_ALGORITHMIA'])
  end

  def get_content(input)
    wikipedia_parser = client_algorithmia.algo('web/WikipediaParser/0.1.2')
    wikipedia_parser.pipe(input).result['content']
  end

  def content_into_sentences(input)
    sentence_split = client_algorithmia.algo('StanfordNLP/SentenceSplit/0.1.0')

    sentence_split.pipe(sanitize_content(input)).result.map! do |sentence|
      {
        text: sentence,
        keywords: [],
        images: []
      }
    end
  end

  def sanitize_content(array)
    array = array.split("\n")
    array.reject! { |item| item.start_with?('=') }
    array.reject!(&:empty?)
    array.map! { |item| item.gsub(/\((?:\([^()]*\)|[^()])*\)/, '').gsub(/  /, ' ') }
    array.join(' ')
  end
end
