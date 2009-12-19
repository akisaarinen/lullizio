require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_youtube.rb'

class TestModule_Youtube < Test::Unit::TestCase
  context "Youtube module" do
    setup do
      @bot = mock()
      @module = Module_Youtube.new
      @module.init_module(@bot)
    end

    should "detect and fetch raw youtube URL" do
      uri = "http://www.youtube.com/watch?v=bXjbMIZzAgs"
      exp_result =/^Christmas Light Hero \(Original\) \(rating: [0-9.]+ \([0-9]+\), views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", uri)
    end

    should "detect and fetch youtube URL from text with feature=related" do
      uri = "http://www.youtube.com/watch?v=7IydwcuGvAI&feature=related"
      exp_result =/^Snoopy vs the Red Baron \(rating: [0-9.]+ \([0-9]+\), views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", " uri within text #{uri} lala")
    end
  end
end
