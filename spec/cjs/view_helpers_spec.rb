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

end
