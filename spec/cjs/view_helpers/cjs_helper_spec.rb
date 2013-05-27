# encoding: utf-8
require 'spec_helper'

describe Codus::ViewHelpers::CjsHelper do
  let(:helper) { Class.new(ActionView::Base) do
      include Codus::ViewHelpers #need javascript_ready
    end.new
  }

  describe "load_cjs" do 
    before(:each) { helper.stub!(:params).and_return({ :action => "nomeaction", :controller => "nomecontroller" }.with_indifferent_access) }

    specify do
      generator_mock = mock()
      generator_mock.should_receive(:generate_cjs_calls).and_return("<script>JAVASCRIPTDERETORNO</script>")
      Codus::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.should_receive(:new).with("nomecontroller", "nomeaction", {:app_name => 'app_teste'}).and_return(generator_mock)
      helper.load_cjs(:app_name => 'app_teste').should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\n&lt;script&gt;JAVASCRIPTDERETORNO&lt;/script&gt;});\n//]]>\n</script>"
    end
  end
end

describe Codus::ViewHelpers::CjsHelper::CjsOnloadCallGenerator do 
  subject { Codus::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.new("ns2", "ns3", {:app_name => "ns1"}) }
  describe "generate_cjs_calls" do 
    specify do
      namespaces_array = ["ns1", "ns1.ns2", "ns1.ns2.ns3"]
      namespaces_array_with_method = ["ns1.load", "ns1.ns2.load", "ns1.ns2.ns3.load", "ns1.ns2.ns3.load"]
      conditional_callings = [
          "\n          if (cJS.isDefined(\"ns2\")) {\n            cJS.call(\"ns2\");\n          }\n        ",
          "\n          if (cJS.isDefined(\"ns4.ng5\")) {\n            cJS.call(\"ns4.ng5\");\n          }\n        "]
      subject.should_receive(:get_all_namespaces_from_full_namespace).and_return(namespaces_array)
      subject.should_receive(:append_onload_method_to_namespaces).with(namespaces_array).and_return(namespaces_array_with_method)
      subject.should_receive(:generate_conditional_function_calling_for_namespaces).with(namespaces_array_with_method).and_return(conditional_callings)
      subject.generate_cjs_calls.should be == "\n          if (cJS.isDefined(\"ns2\")) {\n            cJS.call(\"ns2\");\n          }\n        \n\n          if (cJS.isDefined(\"ns4.ng5\")) {\n            cJS.call(\"ns4.ng5\");\n          }\n        "
    end
  end

  describe "get_all_namespaces_from_full_namespace" do
    specify { subject.get_all_namespaces_from_full_namespace.should be == %w(ns1 ns1.ns2 ns1.ns2.ns3)}

    it "should return mapped ns names" do 
      generator = Codus::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.new("ns2", "create", {:app_name => "ns1", :method_names_mapper => {:create => "novo"}})
      generator.get_all_namespaces_from_full_namespace().should be == %w(ns1 ns1.ns2 ns1.ns2.create ns1.ns2.novo)
      generator = Codus::ViewHelpers::CjsHelper::CjsOnloadCallGenerator.new("ns2", "edit", {:app_name => "ns1", :method_names_mapper => {:create => "novo"}})
      generator.get_all_namespaces_from_full_namespace().should be == %w(ns1 ns1.ns2 ns1.ns2.edit)
    
    end
  end

  describe "append_onload_method_to_namespaces" do 
    context "empty method name" do 
      specify { subject.append_onload_method_to_namespaces(["ns2", "ns4.ng5"]).should be == ["ns2", "ns4.ng5"] }
    end

    context "method name not empty" do 
      specify do 
        subject.instance_eval { @options[:onload_method_name] = "onload_method"}
        subject.append_onload_method_to_namespaces(["ns2", "ns4.ng5"]).should be == ["ns2.onload_method", "ns4.ng5.onload_method"] 
      end
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
