require 'tty-prompt'
require 'dotenv/load'
require 'algorithmia'
require 'json'
require 'ibm_watson/authenticators'
require 'ibm_watson/natural_language_understanding_v1'
require 'down'
require 'fileutils'
require 'mini_magick'
require 'byebug'

require File.expand_path('robots/state.rb')
require File.expand_path('robots/input.rb')
require File.expand_path('robots/text.rb')
require File.expand_path('robots/image.rb')
require File.expand_path('robots/video.rb')
require File.expand_path('lib/video_maker.rb')
