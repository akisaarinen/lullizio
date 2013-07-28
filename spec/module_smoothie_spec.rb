# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_smoothie.rb'

describe 'Module_Smoothie' do
  context "Smoothie module" do
    before(:each) do
      @bot = double()
      @module = Module_Smoothie.new
      @module.init_module(@bot)
    end

    it "calculate kcals for known ingredients" do 
      exp_result = "Laskennallinen energiasisältö: 228.6 kcal"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "!smoothie omena:150 paaryna:150 nakki:20 tropicana:100")
    end
  end
end
