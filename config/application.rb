require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module HireflowAi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths << Rails.root.join("app/services")
    config.autoload_paths << Rails.root.join("app/queries")
    config.active_job.queue_adapter = :sidekiq
    config.generators.system_tests = nil
    config.time_zone = "UTC"
  end
end
