require 'rails/engine'
require "codus/version"
require "codus/view_helpers"

module Codus
  class Engine < ::Rails::Engine
    initializer "Codus.view_helpers" do |app|
      ActionView::Base.send :include, Codus::ViewHelpers
    end
  end
end
