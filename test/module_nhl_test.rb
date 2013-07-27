# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_nhl.rb'

class TestModule_Nhl < Test::Unit::TestCase
  context "NHL module" do
    setup do
      @bot = mock()
      @module = Module_Nhl.new
      @module.init_module(@bot)
    end
    
    should "not reply to random text" do
      text = "foo bar baz"
      @module.privmsg(@bot, "someone", "#channel", text)
    end
  end

  def fake_time
    fake_now = Time.local(2011,8,24)
    @module.stubs(:time_now).returns(fake_now)
  end
end
