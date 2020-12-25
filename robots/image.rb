require 'google/apis/customsearch_v1'

module Image
  def fetch_images_of_all_sentences
    @data_structure = load_content_json

    @data_structure['sentences'].each do |sentence|
      sentence['google_search_query'] = "#{@data_structure['search_term']} #{sentence['keywords'][0]}"
      sentence['images'] = link_of_images(sentence['google_search_query'])
    end

    download_all_images(@data_structure)
    save_content_as_json(@data_structure)
  end

  def link_of_images(search_query)
    response = search_client.list_cses(q: search_query, cx: ENV['GOOGLE_CSE'], search_type: 'image', num: '10')
    response.items.map(&:link)
  end

  def search_client
    searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
    searcher.key = ENV['KEY_GOOGLE_CLOUD']
    searcher
  end

  def download_all_images(_data_structure)
    @data_structure['downloaded_images'] = []

    @data_structure['sentences'].each_with_index do |sentence, index|
      sentence['images'].each do |image|
        next unless Request.img?(image) && @data_structure['downloaded_images'].none? { |n| image == n }

        tempfile = Down.download(image)
        FileUtils.mv(tempfile.path, "./images/#{index}-#{tempfile.original_filename}")
        @data_structure['downloaded_images'] << image
        break
      end
    end
  end
end

module Request
  def self.img?(url)
    Net::HTTP.get_response(URI.parse(url)).content_type.include?('image/')
  rescue StandardError
    false
  end
end
