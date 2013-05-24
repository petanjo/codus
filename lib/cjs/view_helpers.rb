module Cjs
  module ViewHelpers
    def javascript_ready(&block)
      javascript_tag("$(function(){\n" + capture(&block) + "});").html_safe
    end

    def load_cjs(options = {})
      options_merged = merge_options_with_defaults(options)
      parent_namespace = "#{options_merged[:app_name]}.#{params[:controller].parameterize('.')}"
      last_namespace = params[:action].parameterize(".")
      generate_onload_cjs_caller("#{parent_namespace}.#{last_namespace}").html_safe
    end

    def generate_onload_cjs_caller(fullnamespace)
      # onload_caller_javascript = javascript_ready do 
      #   namespaces_to_call_onload = []
      #   "#{parent_namespace}.#{last_namespace}".split(".").each do |actual_namespace| 
      #     if namespaces_to_call_onload.empty?
      #       namespaces_to_call_onload << actual_namespace
      #     else
      #       namespaces_to_call_onload << ("#{namespaces_to_call_onload.last}.#{actual_namespace}")
      #     end
      #   end

      #   if options_merged[:method_names_mapper].has_key?(last_namespace.to_sym)
      #     namespaces_to_call_onload << ("#{parent_namespace}.#{options_merged[:method_names_mapper][last_namespace.to_sym]}")
      #   end
        
      #   onload_calls_definitions = namespaces_to_call_onload.map do |namespace_to_call_onload|
      #     if options_merged[:onload_method_name].blank?
      #       namespace_to_call_onload
      #     else
      #       "#{namespace_to_call_onload}.#{options_merged[:onload_method_name]}"
      #     end
      #   end

      #   conditional_callings = onload_calls_definitions.map do |call_definition| 
      #     %Q{
      #       if (cJS.isDefined("#{call_definition}")) {
      #         cJS.call("#{call_definition}");
      #       }
      #     }
      #   end

      #   conditional_callings.join("\n").html_safe
      # end

      # onload_caller_javascript.html_safe
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