require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_spotify.rb'

class TestModule_Spotify < Test::Unit::TestCase
  context "Spotify module" do
    setup do
      @bot = mock()
      @module = Module_Spotify.new
      @module.init_module(@bot)
    end
    
    should "reply to spotify track with single artist" do
      uri = "http://open.spotify.com/track/0Sc4uoCKkBo6vMYL1ZePot"
      exp_result = 
          "Spotify: Basshunter - Jingle Bells - Bass [2:45] (2006 album Jingle Bells)"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    should "reply to spotify track with multiple artists" do
      uri = "http://open.spotify.com/track/4efcOIkEpWQpOZbEb90yJZ"
      exp_result = 
          "Spotify: Michael Bubl\303\251, The Puppini Sisters - Jingle Bells - feat. The Puppini Sisters [2:39] (2011 album Christmas)"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    should "reply to artist" do
      uri = "http://open.spotify.com/artist/4tZwfgrHOc3mvqYlEYSvVi"
      exp_result = 
          "Spotify artist: Daft Punk"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    should "reply to album" do
      uri = "http://open.spotify.com/album/4LTuhh4qpSn8uUrjhiWTj3"
      exp_result = 
          "Spotify album: Daft Punk - TRON Legacy: Reconfigured (2011)"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    should "reply to playlist" do
      uri = "http://open.spotify.com/user/aki.saarinen/playlist/0gjvtUd1utQnMQJq66HXxX"
      exp_result = 
          "Spotify playlist: UV11 by aki.saarinen"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
  end
end
