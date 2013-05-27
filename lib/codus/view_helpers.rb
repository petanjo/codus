require "codus/view_helpers/cjs_helper"

module Codus
  module ViewHelpers
    include Codus::ViewHelpers::CjsHelper
    
    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});").html_safe
    end

  end
end