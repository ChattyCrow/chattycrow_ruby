module ChattyCrow
  module ContactsRequest
    include RestClient

    def self.get(options)
      new(:get, options).execute
    end

    def self.add(options)
      new(:add, options).execute
    end

    def self.remove(options)
      new(:remove, options).execute
    end

    def initialize(klass, options)

    end
  end
end
