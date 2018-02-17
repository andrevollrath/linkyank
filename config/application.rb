require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Linkyank
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
      
      console do
        #require 'mechanize'
        #require 'nokogiri'
        #require our scraper classes
        require 'scraper'
        Rails::ConsoleMethods.send :include, Scraper::Console
        
    end  

  end
end
