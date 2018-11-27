# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    # Configure the client for all specs using an environment variable
    GabApi::Client.access_token = ENV['GAB_OAUTH_TOKEN']
    GabApi::Client.instance
  end
end
