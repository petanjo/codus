require "codus/view_helpers/yojs_helper"

module Codus
  module ViewHelpers
    include Codus::ViewHelpers::YojsHelper
    
    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});").html_safe
    end

  end
end