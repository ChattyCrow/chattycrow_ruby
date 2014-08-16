# Parent of all ChattyCrow errors
module ChattyCrow
  module Error
    class ChattyCrowError < StandardError
    end
  end
end

Dir[File.dirname(__FILE__) + '/error/*.rb'].sort.each do |path|
  filename = File.basename(path)
  require "chatty_crow/error/#{filename}"
end
