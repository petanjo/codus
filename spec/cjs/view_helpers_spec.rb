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

end
