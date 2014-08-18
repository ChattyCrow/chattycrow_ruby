# Parent of all ChattyCrow errors
module ChattyCrow
  module Error
    class ChattyCrowError < StandardError

      attr_accessor :response_body

      def initialize(response = nil)
        @response_body = JSON.parse(response.body) if response
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/error/*.rb'].sort.each do |path|
  filename = File.basename(path)
  require "chatty_crow/error/#{filename}"
end
