require 'rails/engine'
require "cjs/version"
require "cjs/view_helpers"

module Cjs
  class Engine < ::Rails::Engine
    initializer "Cjs.view_helpers" do |app|
      ActionView::Base.send :include, Cjs::ViewHelpers
    end
  end
end
