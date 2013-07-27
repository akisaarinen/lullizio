# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_lmgtfy.rb'

class TestModule_Lmgtfy < Test::Unit::TestCase
  context "Lmgtfy module" do
    setup do
      @bot = mock()
      @module = Module_Lmgtfy.new
      @module.init_module(@bot)
    end

    should "reply to anonymous lmgtfy request" do
      @bot.expects(:send_privmsg).with("#channel", "http://lmgtfy.com/?q=some%20sentence")
      @module.privmsg(@bot, "someone", "#channel", "g some sentence")
    end

    should "reply to targeted lmgtfy request" do
      @bot.expects(:send_privmsg).with("#channel", "target: http://lmgtfy.com/?q=some%20sentence")
      @module.privmsg(@bot, "someone", "#channel", "target: g some sentence")
    end
  end
end
