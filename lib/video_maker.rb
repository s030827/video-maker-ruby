class VideoMaker
  include State
  include Input
  include Text
  include Image

  attr_accessor :data_structure

  def initialize
    @data_structure = {}

    ask_terms
    fetch_content_from_wikipedia
    fetch_images_of_all_sentences
  end
end

