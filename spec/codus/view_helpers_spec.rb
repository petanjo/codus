# encoding: utf-8
require 'spec_helper'

describe Codus::ViewHelpers do
  let(:helper) { Class.new(ActionView::Base) do
      include Codus::ViewHelpers
    end.new
  }

  describe "javascript_ready" do
    specify do
      helper.javascript_ready do
        "CONTEUDO JAVASCRIPT"
      end.should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\nCONTEUDO JAVASCRIPT});\n//]]>\n</script>"
    end
  end

  describe 'classes_for_scoped_css' do
    specify do
      helper.stub(:params).and_return({controller: 'controller_name', action: 'actionname'})
      helper.should_receive(:current_layout).and_return('layoutname')
      helper.classes_for_scoped_css.should == "layoutname-layout controller-name-controller actionname-action"
    end
  end

  describe 'current_layout' do
    specify do
      helper.stub_chain(:controller, :send).and_return("layoutname")
      helper.current_layout.should == "layoutname"
    end
  end
end
