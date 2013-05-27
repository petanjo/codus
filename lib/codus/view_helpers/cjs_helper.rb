require "codus/view_helpers/cjs_helper/cjs_call_generator"

module Codus
  module ViewHelpers
    module CjsHelper
      def load_cjs(options = {})
        call_generator = CjsCallGenerator.new(params[:controller], params[:action], options)
        javascript_ready { call_generator.generate_cjs_calls() }.html_safe
      end
    end
  end
end