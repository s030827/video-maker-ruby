require 'google/apis/customsearch_v1'

module Image
  def fetch_images_of_all_sentences
    @data_structure = load_content_json

    @data_structure['sentences'].each do |sentence|
      sentence['google_search_query'] = "#{@data_structure['search_term']} #{sentence['keywords'][0]}"
      sentence['images'] = link_of_images(sentence['google_search_query'])
    end

    save(@data_structure)
  end

  def link_of_images(search_query)
    response = search_client.list_cses(search_query, cx: ENV['GOOGLE_CSE'], search_type: 'image', num: '2')
    response.items.map(&:link)
  end

  def search_client
    searcher = Google::Apis::CustomsearchV1::CustomsearchService.new
    searcher.key = ENV['KEY_GOOGLE_CLOUD']
    searcher
  end
end
