module ChattyCrow
  # ChattyCrow rails integration
  class Railtie < ::Rails::Railtie
    initializer 'chatty_crow.initialize_from_rails' do
      config.after_initialize do
        ChattyCrow.configure_from_rails
      end
    end
  end
end
