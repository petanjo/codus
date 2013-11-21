require "codus/view_helpers/yojs_helper"

module Codus
  module ViewHelpers
    include Codus::ViewHelpers::YojsHelper

    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});").html_safe
    end

    def current_layout
      layout = controller.send(:_layout)

      if layout.instance_of? String
        layout.split('/').last
      else
        File.basename(layout.identifier).split('.').first
      end
    end

    def classes_for_scoped_css
      classes = []
      classes << "#{current_layout}-layout"
      classes << "#{params[:controller].parameterize('-')}-controller"
      classes << "#{params[:action].parameterize('-')}-action"
      classes.join(" ")
    end
  end
end