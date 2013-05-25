require "cjs/view_helpers/cjs_helper"

module Cjs
  module ViewHelpers
    include Cjs::ViewHelpers::CjsHelper
    
    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});").html_safe
    end

  end
end