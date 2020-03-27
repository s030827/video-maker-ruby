module Text
  def fetch_content_from_wikipedia
    @data_structure['source_content_original'] = get_content(@data_structure['searchTerm'])
    @data_structure['source_content_sanitize'] = content_sanitized(@data_structure['source_content_original'])
    @data_structure['sentences']               = get_sentences(@data_structure['source_content_sanitize'])
    save(@data_structure)
  end

  def get_content(input)
    instance_of_algorithmia.algo('web/WikipediaParser/0.1.2').pipe(input).result['content']
  end

  def content_sanitized(input)
    input = input.split("\n")
    input.reject! { |item| item.start_with?('=') }
    input.reject!(&:empty?)
    input.map! { |item| item.gsub(/\((?:\([^()]*\)|[^()])*\)/, '').gsub(/  /, ' ') }
    input.join(' ')
  end

  def get_sentences(input)
    content_into_sentences(input).map! do |sentence|
      keywords = fetch_keywords_from_sentence(sentence)

      {
        text: sentence,
        keywords: keywords,
        images: []
      }
    end
  end

  def content_into_sentences(input)
    instance_of_algorithmia.algo('StanfordNLP/SentenceSplit/0.1.0').pipe(input).result.slice(0, 7)
  end

  def fetch_keywords_from_sentence(sentence)
    watson_natural_language_understanding.analyze(
      text: sentence,
      features: {
        keywords: {}
      }
    ).result['keywords'].map { |k| k.fetch('text') }
  end

  def watson_natural_language_understanding
    IBMWatson::NaturalLanguageUnderstandingV1.new(
      authenticator: instance_of_watson,
      version: '2018-03-16',
      service_url: ENV['URL_NATURAL_LANGUAGE']
    )
  end

  def instance_of_algorithmia
    Algorithmia.client(ENV['KEY_ALGORITHMIA'])
  end

  def instance_of_watson
    IBMWatson::Authenticators::IamAuthenticator.new(
      apikey: ENV['KEY_WATSON']
    )
  end
end
