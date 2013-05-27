require "codus/view_helpers/yojs_helper/yojs_call_generator"

module Codus
  module ViewHelpers
    module YojsHelper
      def load_yojs(options = {})
        call_generator = YojsCallGenerator.new(params[:controller], params[:action], options)
        javascript_ready { call_generator.generate_yojs_calls() }.html_safe
      end
    end
  end
end