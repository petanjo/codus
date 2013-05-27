module Codus
  module ViewHelpers
    module CjsHelper
      class CjsCallGenerator
        def initialize(controller, action, options = {})
          @options = merge_options_with_defaults(options)
          @parent_namespace = "#{@options[:app_name]}.#{controller.parameterize('.')}"
          @last_namespace = action.parameterize(".")
          @fullnamespace = "#{@parent_namespace}.#{@last_namespace}"
          
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

        def generate_cjs_calls
          namespaces_to_call_onload = get_all_namespaces_from_full_namespace
          onload_calls_definitions = append_onload_method_to_namespaces(namespaces_to_call_onload)
          conditional_callings = generate_conditional_function_calling_for_namespaces(onload_calls_definitions)
          conditional_callings.join("\n").html_safe
        end

        def get_all_namespaces_from_full_namespace
          namespaces = []
          @fullnamespace.split(".").each do |actual_namespace| 
            if namespaces.empty?
              namespaces << actual_namespace
            else
              namespaces << ("#{namespaces.last}.#{actual_namespace}")
            end
          end
          if @options[:method_names_mapper].has_key?(@fullnamespace.split(".").last.to_sym)
            namespaces << ("#{@parent_namespace}.#{@options[:method_names_mapper][@last_namespace.to_sym]}")
          end
          namespaces
        end

        def append_onload_method_to_namespaces(namespaces = [])
          return namespaces if @options[:onload_method_name].nil? || @options[:onload_method_name] == ""
          namespaces.map do |namespace_to_call_onload|
            "#{namespace_to_call_onload}.#{@options[:onload_method_name]}"
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

        
      end

    end
  end
end