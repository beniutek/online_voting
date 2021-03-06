require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
require_relative "../../lib/online_voting/rsa_blind_signer.rb"
require_relative "../../lib/online_voting/admin_client.rb"
require_relative "../../lib/online_voting/crypto/message.rb"

Dir[
  File.expand_path("lib/voter.rb"),
].each do |file|
  require file
end
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Voter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoload_paths += %W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.voter = ActiveSupport::OrderedOptions.new
    config.voter.administrator_module_uri = ENV['ADMINISTRATOR_MODULE_URI']
    config.voter.administrator_public_key_uri = ENV['ADMINISTRATOR_MODULE_PUBLIC_KEY_URI'] || "http://localhost:3030/public-key"
    config.voter.counter_module_uri = ENV['COUNTER_MODULE_URI']
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource(
          '*',
          headers: :any,
          methods: [:get, :patch, :put, :delete, :post, :options]
          )
      end
    end
  end
end
