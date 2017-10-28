
ENV["VLO_DEBUG"] = 'true'

##
# Print a debug message if environment var VLO_DEBUG is true
def debug(message)
  warn "==== VLO DEBUG: " + message if ENV["VLO_DEBUG"] == 'true'
end

require_relative 'cli/cli'
require_relative 'api/vlo_api'

