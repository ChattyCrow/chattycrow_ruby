module ChattyCrow
  module NotificationRequest
    include RestClient

    def self.send(klass, options)
      new(klass, options).execute
    end

    def initialize(klass, options)

    end
  end
end
