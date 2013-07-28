# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_lmgtfy.rb'

describe 'Module_Lmgtfy' do
  context "Lmgtfy module" do
    before(:each) do
      @bot = double()
      @module = Module_Lmgtfy.new
      @module.init_module(@bot)
    end

    it "reply to anonymous lmgtfy request" do
      expect(@bot).to receive(:send_privmsg).with("#channel", "http://lmgtfy.com/?q=some%20sentence")
      @module.privmsg(@bot, "someone", "#channel", "g some sentence")
    end

    it "reply to targeted lmgtfy request" do
      expect(@bot).to receive(:send_privmsg).with("#channel", "target: http://lmgtfy.com/?q=some%20sentence")
      @module.privmsg(@bot, "someone", "#channel", "target: g some sentence")
    end
  end
end
