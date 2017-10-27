HOME = Dir.pwd

require "#{HOME}/lib/api/vlo_api.rb"
require 'nokogiri'

api = VloApi.new()

result = api.getPage('/')

IO.write("#{HOME}/html/index.html", result)

