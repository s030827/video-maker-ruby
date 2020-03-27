class VideoMaker
  include State
  include Input
  include Text

  attr_accessor :data_structure

  def initialize
    @data_structure = {}

    ask_terms
    fetch_content_from_wikipedia
    load_content_json
  end
end

