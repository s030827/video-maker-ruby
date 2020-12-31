module Video
  def produce_video
    @data_structure = load_content_json

    convert_all_images(@data_structure)
    compose_final_images
    youtube_thumbnail
    render_video
  end

  def convert_all_images(_data_structure)
    array_name_images = Dir['./images/*'].select { |f| File.file? f }.map { |f| File.basename f }.sort

    array_name_images.each do |name_of_image|
      blur_image = MiniMagick::Image.open("./images/#{name_of_image}")
      image = MiniMagick::Image.open("./images/#{name_of_image}")

      blur_image.background 'white'
      blur_image.blur '0x15'
      blur_image.resize '1920x1080!'

      image.background 'white'
      image.resize '1920x1080'

      result = blur_image.composite(image) do |image_convert|
        image_convert.gravity 'Center'
        image_convert.compose 'Over'
      end

      result.write "./images/#{name_of_image.split('.').first}-converted.jpg"
      system(
        "convert -size 500x500 -background 'transparent' -fill 'white' caption:'#{@data_structure['sentences'][name_of_image[0].to_i]['text']}' ./images/#{name_of_image.split('.').first}-sentence.png"
      )
    end
  end

  def compose_final_images
    images_converted = Dir['./images/*'].select { |f| File.file? f }.map { |f| File.basename f }.select! { |f| f.match /converted/ }.sort
    images_sentence  = Dir['./images/*'].select { |f| File.file? f }.map { |f| File.basename f }.select! { |f| f.match /sentence/ }.sort

    images_converted.each_with_index do |final_images, index|
      converted = MiniMagick::Image.open("./images/#{final_images}")
      sentence  = MiniMagick::Image.open("./images/#{images_sentence[index]}")

      result = converted.composite(sentence) do |image_convert|
        image_convert.gravity 'Center'
        image_convert.compose 'Over'
      end

      result.write "./images/#{index}-final.jpg"
    end
  end

  def youtube_thumbnail
    image = Dir['./images/*'].select { |f| File.file? f }.map { |f| File.basename f }.select! { |f| f.match /converted/ }.first
    thumbnail = MiniMagick::Image.open("./images/#{image}")
    thumbnail.resize '1280x720!'
    thumbnail.write './images/youtube-thumbnail.jpg'
  end

  def render_video
    system(
      "ffmpeg -framerate 10 -pattern_type glob -i './images/*final.jpg' -c:v libx264 -filter:v \"setpts=15.0*PTS\" -pix_fmt yuv420p './images/output.mp4'"
    )
  end
end
