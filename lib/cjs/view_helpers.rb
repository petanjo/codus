module Cjs
  module ViewHelpers
    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});")
    end

    def load_cjs(options = {})
      options_merged = merge_options_with_defaults(options)
      parent_namespace = "#{options_merged[:app_name]}.#{params[:controller].parameterize('.')}"
      last_namespace = params[:action].parameterize(".")

      onload_caller_javascript = javascript_ready do 
        namespaces_to_call_onload = []
        "#{parent_namespace}.#{last_namespace}".split(".").each do |actual_namespace| 
          if namespaces_to_call_onload.empty?
            namespaces_to_call_onload << actual_namespace
          else
            namespaces_to_call_onload << ("#{namespaces_to_call_onload.last}.#{actual_namespace}")
          end
        end

        if options_merged[:method_names_mapper].has_key?(last_namespace.to_sym)
          namespaces_to_call_onload << ("#{parent_namespace}.#{options_merged[:method_names_mapper][last_namespace.to_sym]}")
        end
        
        onload_calls_definitions = namespaces_to_call_onload.map do |namespace_to_call_onload|
          if options_merged[:onload_method_name].blank?
            namespace_to_call_onload
          else
            "#{namespace_to_call_onload}.#{options_merged[:onload_method_name]}"
          end
        end

        conditional_callings = onload_calls_definitions.map do |call_definition| 
          %Q{
            if (cJS.isDefined("#{call_definition}")) {
              cJS.call("#{call_definition}");
            }
          }
        end

        conditional_callings.join("\n").html_safe
      end

      onload_caller_javascript
    end

    def merge_options_with_defaults(options)
      { :app_name => "", 
        :onload_method_name => "",
        :method_names_mapper => {
          :create => :new,
          :update => :edit
        }
      }.merge(options)
    end
  end
end