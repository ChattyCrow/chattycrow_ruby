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

        # If there is arguments, that means on input was a string!
        # That can be, GCM don't allow to pass a string instead of
        # Hash!
        if @arguments.any? && !@arguments[0].is_a?(Hash)
          raise ::ArgumentError, 'In Android GCM notification parameter has to be a hash'
        end

        # Set arguments hash, allow entry:
        # ChattyCrow.send_android({key: value, key2: value2}, collapse_key: '')
        if @arguments.any?
          @data = @arguments[0]
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
