# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_spotify.rb'

describe 'Module_Spotify' do
  context "Spotify module" do
    before(:each) do
      @bot = double()
      @module = Module_Spotify.new
      @module.init_module(@bot)
    end
    
    it "reply to spotify track with single artist" do
      uri = "http://open.spotify.com/track/0Sc4uoCKkBo6vMYL1ZePot"
      exp_result = 
          "Spotify: Basshunter - Jingle Bells - Bass [2:46] (2006 album Jingle Bells)"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    it "reply to spotify track with multiple artists" do
      uri = "http://open.spotify.com/track/4efcOIkEpWQpOZbEb90yJZ"
      exp_result = 
          "Spotify: Michael Bublé - Jingle Bells - feat. The Puppini Sisters [2:40] (2011 album Christmas)"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    it "reply to artist" do
      uri = "http://open.spotify.com/artist/4tZwfgrHOc3mvqYlEYSvVi"
      exp_result = 
          "Spotify artist: Daft Punk"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    it "reply to album" do
      uri = "http://open.spotify.com/album/4LTuhh4qpSn8uUrjhiWTj3"
      exp_result = 
          "Spotify album: Daft Punk - TRON Legacy: Reconfigured (2011)"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    it "reply to playlist" do
      uri = "http://open.spotify.com/user/aki.saarinen/playlist/0gjvtUd1utQnMQJq66HXxX"
      exp_result = 
          "Spotify playlist: UV11 by aki.saarinen"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
  end
end
