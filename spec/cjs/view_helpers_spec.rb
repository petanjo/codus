# encoding: utf-8
require 'spec_helper'

describe Cjs::ViewHelpers do
  let(:helper) { Class.new(ActionView::Base) do
      include Cjs::ViewHelpers
    end.new
  }

  before(:each) { helper.stub!(:params).and_return({ :action => "nomeaction", :controller => "nomecontroller" }.with_indifferent_access) }

  describe "javascript_ready" do 
    specify do
      helper.javascript_ready do
        "CONTEUDO JAVASCRIPT"
      end.should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\nCONTEUDO JAVASCRIPT});\n//]]>\n</script>"
    end
  end

  describe "load_cjs" do 
    specify do
      helper.should_receive(:generate_onload_cjs_caller).with("app_teste.nomecontroller.nomeaction").and_return("<script>JAVASCRIPTDERETORNO</script>")
      helper.load_cjs(:app_name => 'app_teste').should be == "<script>JAVASCRIPTDERETORNO</script>"
    end
  end

  describe "generate_onload_cjs_caller" do 
    specify do
      fullnamespace = "ns1.ns2.ns3"
      namespaces_array = ["ns1", "ns1.ns2", "ns1.ns2.ns3"]
      namespaces_array_with_method = ["ns1.load", "ns1.ns2.load", "ns1.ns2.ns3.load", "ns1.ns2.ns3.load"]
      helper.should_receive(:get_all_namespaces_from_full_namespace).with(fullnamespace).and_return(namespaces_array)
      helper.should_receive(:append_method_to_namespaces).and_return(namespaces_array_with_method)
      helper.generate_onload_cjs_caller(fullnamespace).should be == "<script>JAVASCRIPTDERETORNO</script>"
    end
  end

  describe "get_all_namespaces_from_full_namespace" do
    specify { helper.get_all_namespaces_from_full_namespace("ns1.ns2.ns3").should be == %w(ns1 ns1.ns2 ns1.ns2.ns3)}
  end

  describe "append_method_to_namespaces" do 
    context "empty_method_name" do 
      specify { helper.append_method_to_namespaces(["ns2", "ns4.ng5"]).should be == ["ns2", "ns4.ng5"] }
    end

    context "method_name_not_empty" do 
      specify { helper.append_method_to_namespaces(["ns2", "ns4.ng5"], "method_name").should be == ["ns2.method_name", "ns4.ng5.method_name"] }
    end
  end

  describe "generate_conditional_function_calling_for_namespaces" do 
    specify do helper.generate_conditional_function_calling_for_namespaces(["ns2", "ns4.ng5"]).should be == [
          "\n          if (cJS.isDefined(\"ns2\")) {\n            cJS.call(\"ns2\");\n          }\n        ",
          "\n          if (cJS.isDefined(\"ns4.ng5\")) {\n            cJS.call(\"ns4.ng5\");\n          }\n        "]
    end
  end
  
  describe "merge_options_with_defaults" do 
    describe "default_values" do 
      specify { helper.merge_options_with_defaults({})[:app_name].should be == ""}
      specify { helper.merge_options_with_defaults({})[:onload_method_name].should be == ""}
      specify { helper.merge_options_with_defaults({})[:method_names_mapper].should include({
          :create => :new,
          :update => :edit
        }) 
      }
    end

    context "merging parameters" do 
      specify do
        helper.merge_options_with_defaults({:app_name => "NOMETESTE"})[:app_name].should be == "NOMETESTE"
      end

      specify do 
        helper.merge_options_with_defaults({:onload_method_name => "NOMETESTE"})[:onload_method_name].should be == "NOMETESTE"
      end

      specify do 
        helper.merge_options_with_defaults({:method_names_mapper => {:rota => :novo_nome}})[:method_names_mapper].should include({
          :create => :new,
          :update => :edit,
          :rota => :novo_nome
        }) 
      end

      specify do 
        customized_options =  helper.merge_options_with_defaults({
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
