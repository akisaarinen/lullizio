require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_smoothie.rb'

class TestModule_Smoothie < Test::Unit::TestCase
  context "Smoothie module" do
    setup do
      @bot = mock()
      @module = Module_Smoothie.new
      @module.init_module(@bot)
    end

    should "calculate kcals for known ingredients" do 
      exp_result = "Laskennallinen energiasisältö: 228.6 kcal"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "!smoothie omena:150 paaryna:150 nakki:20 tropicana:100")
    end
  end
end
