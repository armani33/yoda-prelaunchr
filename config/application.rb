require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YodaPrelaunchr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.session_store(
      :cookie_store,
      key: '_yoda_session', # any value
      expire_after: 30.weeks.from_now.utc
    )

    # decides whether the prelaunch campaign has ended or not
    config.ended = ENV['CAMPAIGN_ENDED'].to_s == 'false'
  end
end
