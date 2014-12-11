require 'yaml'

# Configuration module
module ChattyCrow
  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure_from_yaml(path)
    yaml = YAML.load_file(path)[Rails.env]
    return unless yaml
    configuration.host            = yaml['host']
    configuration.token           = yaml['token']
    configuration.default_channel = yaml['default_channel']
  end

  def self.configure_from_rails
    path = ::Rails.root.join('config', 'chatty_crow.yml')
    configure_from_yaml(path) if File.exist?(path)
  end

  def self.default_headers(channel, token)
    batch_headers(token).merge({ 'Channel' => (channel || configuration.default_channel) })
  end

  def self.batch_headers(token)
    {
      'Token'   => token   || configuration.token,
      'Accept'  => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  # Configuration class
  class Configuration
    # Server settings
    # Default https://chatty-crow.com (https for secure connection)
    attr_accessor :host

    # User and channel settings
    attr_accessor :token, :default_channel

    # Open and read timeouts
    attr_accessor :http_open_timeout
    attr_accessor :http_read_timeout

    # Call urls
    attr_reader :notification_url, :contacts_url, :messages_url, :batch_url

    def initialize
      self.host          = 'https://chattycrow.com/api/v1/'
      @token             = nil
      @default_channel   = nil
      @http_open_timeout = 2
      @http_read_timeout = 5
    end

    def host=(s)
      @host             = s
      @notification_url = s + (s[-1] == '/' ? '' : '/') + 'notification'
      @contacts_url     = s + (s[-1] == '/' ? '' : '/') + 'contacts'
      @messages_url     = s + (s[-1] == '/' ? '' : '/') + 'message'
      @batch_url        = s + (s[-1] == '/' ? '' : '/') + 'batch'
    end
  end
end
