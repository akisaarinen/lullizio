require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_youtube.rb'

class TestModule_Youtube < Test::Unit::TestCase
  context "Youtube module" do
    setup do
      @bot = mock()
      @module = Module_Youtube.new
      @module.init_module(@bot)
    end

    should "do nothing with non-video or broken URLs" do
      @module.privmsg(@bot, "someone", "#channel", "http://www.youtube.com/")
      @module.privmsg(@bot, "someone", "#channel", "http://youtube.com/about")
      @module.privmsg(@bot, "someone", "#channel", "http://youtu.be/invalid")
      @module.privmsg(@bot, "someone", "#channel", "youtu.be/invalid")
      @module.privmsg(@bot, "someone", "#channel", "http://www.youtube.com/watch?v=invalid")
      @module.privmsg(@bot, "someone", "#channel", "http://invalid.youtube.com/watch?v=foo")
    end

    should "detect and fetch raw youtube URL using youtube.com" do
      uri = "http://www.youtube.com/watch?v=bXjbMIZzAgs"
      exp_result =/^Christmas Light Hero.* \[4:26\] \(rating: [0-9]+ likes, [0-9]+ dislikes, views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", uri)
    end

    should "detect and fetch raw youtube URL using youtu.be" do
      uri = "http://youtu.be/bXjbMIZzAgs"
      exp_result =/^Christmas Light Hero.* \[4:26\] \(rating: [0-9]+ likes, [0-9]+ dislikes, views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", uri)
    end

    should "detect and fetch youtube URL from text with feature=related using youtube.com" do
      uri = "http://www.youtube.com/watch?v=7IydwcuGvAI&feature=related"
      exp_result =/^Snoopy vs the Red Baron \[3:09\] \(rating: [0-9]+ likes, [0-9]+ dislikes, views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", " uri within text #{uri} lala")
    end

    should "parse length of a long video correctly" do
      uri = "http://www.youtube.com/watch?v=b5TUw1F5ac8"
      exp_result =/Relaxing Rain On a Metal Roof \(1 Hour Long\) To help you fall asleep \[1:01:11\] \(rating: [0-9]+ likes, [0-9]+ dislikes, views: [0-9]+\)$/
      @bot.expects(:send_privmsg).with("#channel", regexp_matches(exp_result))
      @module.privmsg(@bot, "someone", "#channel", " uri within text #{uri} lala")
    end
  end
end
