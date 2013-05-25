# encoding: utf-8
require 'spec_helper'

describe Cjs::ViewHelpers::CjsHelper do
  let(:helper) { Class.new(ActionView::Base) do
      include Cjs::ViewHelpers #need javascript_do
    end.new
  }

  describe "load_cjs" do 
    before(:each) { helper.stub!(:params).and_return({ :action => "nomeaction", :controller => "nomecontroller" }.with_indifferent_access) }

    specify do
      generator_mock = mock()
      generator_mock.should_receive(:generate_cjs_calls).and_return("<script>JAVASCRIPTDERETORNO</script>")
      Cjs::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.should_receive(:new).with("nomecontroller", "nomeaction", {:app_name => 'app_teste'}).and_return(generator_mock)
      helper.load_cjs(:app_name => 'app_teste').should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\n&lt;script&gt;JAVASCRIPTDERETORNO&lt;/script&gt;});\n//]]>\n</script>"
    end
  end
end

describe Cjs::ViewHelpers::CjsHelper::CjsOnloadCallGenerator do 
  subject { Cjs::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.new("ns2", "ns3", {:app_name => "ns1"}) }
  describe "generate_cjs_calls" do 
    specify do
      namespaces_array = ["ns1", "ns1.ns2", "ns1.ns2.ns3"]
      namespaces_array_with_method = ["ns1.load", "ns1.ns2.load", "ns1.ns2.ns3.load", "ns1.ns2.ns3.load"]
      conditional_callings = [
          "\n          if (cJS.isDefined(\"ns2\")) {\n            cJS.call(\"ns2\");\n          }\n        ",
          "\n          if (cJS.isDefined(\"ns4.ng5\")) {\n            cJS.call(\"ns4.ng5\");\n          }\n        "]
      subject.should_receive(:get_all_namespaces_from_full_namespace).and_return(namespaces_array)
      subject.should_receive(:append_method_to_namespaces).with(namespaces_array).and_return(namespaces_array_with_method)
      subject.should_receive(:generate_conditional_function_calling_for_namespaces).with(namespaces_array_with_method).and_return(conditional_callings)
      subject.generate_cjs_calls.should be == "\n          if (cJS.isDefined(\"ns2\")) {\n            cJS.call(\"ns2\");\n          }\n        \n\n          if (cJS.isDefined(\"ns4.ng5\")) {\n            cJS.call(\"ns4.ng5\");\n          }\n        "
    end
  end

  describe "get_all_namespaces_from_full_namespace" do
    specify { subject.get_all_namespaces_from_full_namespace.should be == %w(ns1 ns1.ns2 ns1.ns2.ns3)}
  end

  describe "append_method_to_namespaces" do 
    context "empty_method_name" do 
      specify { subject.append_method_to_namespaces(["ns2", "ns4.ng5"]).should be == ["ns2", "ns4.ng5"] }
    end

    context "method_name_not_empty" do 
      specify { subject.append_method_to_namespaces(["ns2", "ns4.ng5"], "method_name").should be == ["ns2.method_name", "ns4.ng5.method_name"] }
    end
  end

  describe "generate_conditional_function_calling_for_namespaces" do 
    specify do 
      subject.generate_conditional_function_calling_for_namespaces(["ns2", "ns4.ng5"]).should be == [
        "\n              if (cJS.isDefined(\"ns2\")) {\n                cJS.call(\"ns2\");\n              }\n            ", 
        "\n              if (cJS.isDefined(\"ns4.ng5\")) {\n                cJS.call(\"ns4.ng5\");\n              }\n            "
      ]
    end
  end

  describe "merge_options_with_defaults" do 
    describe "default_values" do 
      specify { subject.merge_options_with_defaults({})[:app_name].should be == ""}
      specify { subject.merge_options_with_defaults({})[:onload_method_name].should be == ""}
      specify { subject.merge_options_with_defaults({})[:method_names_mapper].should include({
          :create => :new,
          :update => :edit
        }) 
      }
    end

    context "merging parameters" do 
      specify do
        subject.merge_options_with_defaults({:app_name => "NOMETESTE"})[:app_name].should be == "NOMETESTE"
      end

      specify do 
        subject.merge_options_with_defaults({:onload_method_name => "NOMETESTE"})[:onload_method_name].should be == "NOMETESTE"
      end

      specify do 
        subject.merge_options_with_defaults({:method_names_mapper => {:rota => :novo_nome}})[:method_names_mapper].should include({
          :create => :new,
          :update => :edit,
          :rota => :novo_nome
        }) 
      end

      specify do 
        customized_options =  subject.merge_options_with_defaults({
          :app_name => "NOMEAPPTESTE",
          :onload_method_name => "NOMELOADTESTE",
          :method_names_mapper => {
            :rota => :novo_nome,
            :create => :createpersonalizado
          }
        })

        customized_options[:app_name].should be == "NOMEAPPTESTE"
        customized_options[:onload_method_name].should be == "NOMELOADTESTE"
        customized_options[:method_names_mapper].should include({
          :update => :edit,
          :rota => :novo_nome,
          :create => :createpersonalizado
        }) 
      end
    end
  end
end
