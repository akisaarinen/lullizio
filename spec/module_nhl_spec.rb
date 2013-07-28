# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_nhl.rb'

describe 'Module_Nhl' do
  context "NHL module" do
    before(:each) do
      @bot = double()
      @module = Module_Nhl.new
      @module.init_module(@bot)
    end
    
    it "not reply to random text" do
      text = "foo bar baz"
      @module.privmsg(@bot, "someone", "#channel", text)
    end
  end

  def fake_time
    fake_now = Time.local(2011,8,24)
    expect(@module).to receive(:time_now).and_return(fake_now)
  end
end
