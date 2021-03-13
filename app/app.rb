ENV["RACK_ENV"] ||= "development"

require "sinatra/base"

require_relative "models/card"

require_relative "controllers/poker"