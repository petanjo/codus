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
      Codus::ViewHelpers::CjsHelper::CjsCallGenerator.should_receive(:new).with("nomecontroller", "nomeaction", {:app_name => 'app_teste'}).and_return(generator_mock)
      helper.load_cjs(:app_name => 'app_teste').should be == "<script type=\"text/javascript\">\n//<![CDATA[\n$(function(){\n&lt;script&gt;JAVASCRIPTDERETORNO&lt;/script&gt;});\n//]]>\n</script>"
    end
  end
end

