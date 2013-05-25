module Cjs
  module ViewHelpers
    module CjsHelper
      class CjsOnloadCallGenerator
        def initialize(fullnamespace, options = {})
        end
      end

      def load_cjs(options = {})
        options_merged = merge_options_with_defaults(options)
        parent_namespace = "#{options_merged[:app_name]}.#{params[:controller].parameterize('.')}"
        last_namespace = params[:action].parameterize(".")
        generate_onload_cjs_caller("#{parent_namespace}.#{last_namespace}").html_safe
      end

      def generate_onload_cjs_caller(fullnamespace)
        namespaces_to_call_onload = get_all_namespaces_from_full_namespace(fullnamespace)
        onload_calls_definitions = append_method_to_namespaces(namespaces_to_call_onload)
        conditional_callings = generate_conditional_function_calling_for_namespaces(onload_calls_definitions)
        javascript_ready { conditional_callings.join("\n").html_safe }.html_safe
      end

      def get_all_namespaces_from_full_namespace(fullnamespace)
        namespaces = []
        fullnamespace.split(".").each do |actual_namespace| 
          if namespaces.empty?
            namespaces << actual_namespace
          else
            namespaces << ("#{namespaces.last}.#{actual_namespace}")
          end
        end
        namespaces
      end

      def append_method_to_namespaces(namespaces = [], method_name = "")
        return namespaces if method_name.nil? || method_name == ""
        namespaces.map do |namespace_to_call_onload|
          "#{namespace_to_call_onload}.#{method_name}"
        end
      end

      def generate_conditional_function_calling_for_namespaces(namespaces = [])
        namespaces.map do |call_definition| 
          "
            if (cJS.isDefined(\"#{call_definition}\")) {
              cJS.call(\"#{call_definition}\");
            }
          "
        end
      end

      def merge_options_with_defaults(options)
        default_options = { :app_name => "", 
          :onload_method_name => "",
          :method_names_mapper => {
            :create => :new,
            :update => :edit
          }
        }
        mapping_options = options.delete(:method_names_mapper)
        default_options[:method_names_mapper].merge!(mapping_options) unless mapping_options.nil? 
        default_options.merge(options)
      end
    end
  end
end