require 'net/http'

# This will be the entry point for the API

class VloApi
  URL = 'https://vlo.informatica.hva.nl'
  
  def getPage(page)
    uri = URI("#{URL}#{page}")
    return Net::HTTP.get(uri)
  end
  
end
