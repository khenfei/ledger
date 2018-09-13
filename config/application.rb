require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Ledger
  class Application < Rails::Application

    config.load_defaults 5.2

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    config.generators.javascript_engine = :js
    
    config.active_record.schema_format = :sql
  end
end
