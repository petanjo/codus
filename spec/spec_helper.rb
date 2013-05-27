ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require 'bundler/setup'
require 'codus' 
require 'action_view'
require 'active_support/all'

include ActionView::Helpers

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
