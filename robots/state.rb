module State
  def save_content_as_json(hash)
    File.open('content.json', 'w') do |file|
      file.write(JSON.pretty_generate(hash))
    end
  end

  def load_content_json
    file = File.read('content.json')
    JSON.parse(file)
  end
end
