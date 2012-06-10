require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_twitter.rb'

class TestModule_Twitter < Test::Unit::TestCase
  context "Twitter module" do
    setup do
      @bot = mock()
      @module = Module_Twitter.new
      @module.init_module(@bot)
    end
    
    should "not reply to twitter homepage with HTTP" do
      uri = "http://twitter.com"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "not reply to twitter homepage with HTTPS" do
      uri = "https://twitter.com"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to twitter status with HTTP using standard URLs" do
      uri = "http://twitter.com/beyondcontent/statuses/74248480662622209" 
      exp_result = 
        "@beyondcontent (Andrew McGarry): " + 
        "Ryanair still using cookie history to inflate prices. My folks saved £100 by deleting cookie from yesterday's browsing session."
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to twitter status with HTTPS using standard URLs" do
      uri = "https://twitter.com/beyondcontent/statuses/74248480662622209" 
      exp_result = 
        "@beyondcontent (Andrew McGarry): " + 
        "Ryanair still using cookie history to inflate prices. My folks saved £100 by deleting cookie from yesterday's browsing session."
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to twitter status with HTTP using hashbang URLs" do
      uri = "http://twitter.com/#!/beyondcontent/status/74248480662622209" 
      exp_result = 
        "@beyondcontent (Andrew McGarry): " + 
        "Ryanair still using cookie history to inflate prices. My folks saved £100 by deleting cookie from yesterday's browsing session."
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to twitter status with HTTPS using hashbang URLs" do
      uri = "https://twitter.com/#!/beyondcontent/status/74248480662622209" 
      exp_result = 
        "@beyondcontent (Andrew McGarry): " + 
        "Ryanair still using cookie history to inflate prices. My folks saved £100 by deleting cookie from yesterday's browsing session."
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
  end
end
