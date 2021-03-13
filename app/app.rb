ENV["RACK_ENV"] ||= "development"

require "sinatra/base"

require_relative "models/card"
require_relative "models/hand"
require_relative "models/player"

require_relative "controllers/poker"