# Configuration
require 'yaml'

module ChattyCrow
  def self.configurate
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure_from_yaml(path)
    yaml = YAML.load_file(path)[Rails.env]
    return unless yaml
    configuration.server_url      = yaml['server_url']
    configuration.token           = yaml['token']
    configuration.default_channel = yaml['default_channel']
  end

  def self.configure_from_rails
    path = ::Rails.root.join('config', 'chatty_crow.yml')
    configure_from_yaml(path) if File.exist?(Path)
  end

  class Configuration
    attr_accessor :server_url, :token, :default_channel

    def initialize
      config = YAML.load_file(File.join(BASE_PATH, 'config', 'config.yml'))
      @server_url      = config['server_url']
      @token           = config['token']
      @default_channel = config['default_channel']
    end
  end
end
