require "rails"

module SpreadBeaver
  class Railtie < ::Rails::Railtie
    config.spread_beaver = ActiveSupport::OrderedOptions.new
    config.spread_beaver.pool_size = 10
    config.spread_beaver.timeout = 20
    config.spread_beaver.bundle = "server-side-bundle.js"

    initializer "spread_beaver.add_watchable_files", group: :all do |app|
      watch_file = "#{Rails.root}/app/assets/javascripts/#{app.config.spread_beaver.bundle}"
      app.config.watchable_files.push watch_file
    end

    config.after_initialize do |app|
      cnf = config.spread_beaver
      setup = -> {
        SpreadBeaver::Runner.setup!(
          app.assets[cnf.bundle].to_s,
          {size: cnf[:pool_size], timeout: cnf[:timeout]}
        )
      }
      setup.call
      ActionDispatch::Reloader.to_prepare(&setup)
    end
  end
end
