require 'tty-prompt'
require 'algorithmia'
require 'json'
require 'ibm_watson/authenticators'
require 'ibm_watson/natural_language_understanding_v1'

require File.expand_path('robots/state.rb')
require File.expand_path('robots/input.rb')
require File.expand_path('robots/text.rb')
require File.expand_path('lib/video_maker.rb')