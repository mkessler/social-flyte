require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Socialflyte
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Load lib classes
    config.autoload_paths += %W(#{config.root}/lib)

    # Load service classes
    config.autoload_paths += %W(#{config.root}/services)

    # Redis
    config.cache_store = :redis_store, "#{Rails.application.secrets.redis_url}cache", { expires_in: 90.minutes }

    # Configure sidekiq
    config.active_job.queue_adapter = :sidekiq
  end
end
