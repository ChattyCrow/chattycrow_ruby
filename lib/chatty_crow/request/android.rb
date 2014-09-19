module ChattyCrow
  module Request
    # Android push notification request
    class Android < BaseRequest
      attr_accessor :data, :collapse_key, :time_to_live

      # Initialize android request
      # @param args [Array] Options
      def initialize(*args)
        super(*args)

        @collapse_key = @options.delete(:collapse_key)
        @time_to_live = @options.delete(:time_to_live)

        # Data must be a hash!
        if @arguments.any?
          @data = @arguments_flatten
        else
          @data = @options
        end
      end

      def payload
        {
          data: @data,
          collapse_key: @collapse_key,
          time_to_live: @time_to_live
        }
      end
    end
  end
end
