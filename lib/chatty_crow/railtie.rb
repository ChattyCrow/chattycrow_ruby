module ChattyCrow
  class Railtie << ::Rails::Railtie
    config.after_initialize do
      ChattyCrow.configure_from_rails
    end
  end
end
