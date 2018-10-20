require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TailTraxAPI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        # location of your API'
        resource '/api/*',
                 :headers => :any,
                 :expose  => ['Access-Token', 'expiry', 'token-type', 'Authorization'],
                 :methods => [:get, :post, :options, :put, :delete]
        resource '/users/*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end
  end
end
