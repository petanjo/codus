ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require 'bundler/setup'
require 'cjs' 
require 'action_view'
require 'active_support'

include ActionView::Helpers

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
