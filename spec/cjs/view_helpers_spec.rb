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
      helper.load_cjs.should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\nCONTEUDO JAVASCRIPT});\n//]]>\n</script>"
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
