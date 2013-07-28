# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_newstitle.rb'

describe 'Module_Newstitle' do
  context "Newstitle module" do
    before(:each) do
      @bot = double()
      @module = Module_Newstitle.new
      @module.init_module(@bot)
    end
    
    it "not reply to HS.fi article with title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/Kysely+Homoparien+vihkiminen+kirkossa+jakaa+kansan+mielipiteet/1135251596656"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    it "reply to HS.fi article without title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/1135251596656"
      exp_result = "Kysely: Homoparien vihkiminen kirkossa jakaa kansan mielipiteet"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end

    it "reply to HS.fi article from RSS without title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/1135251596656?ref=rss"
      exp_result = "Kysely: Homoparien vihkiminen kirkossa jakaa kansan mielipiteet"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    it "reply to Iltalehti.fi article" do
      uri = "http://www.iltalehti.fi/uutiset/2009121910813607_uu.shtml"
      exp_result = "Rekkajono Vaalimaalla pitenee | Kotimaan uutiset"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    it "not reply to a jpg image from Iltalehti.fi" do
      uri = "http://static.iltalehti.fi/viihde/mikasalo_vaaka1102MN_503_vi.jpg"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
   
    it "not reply to a jpeg image from Iltalehti.fi" do
      uri = "http://static.iltalehti.fi/viihde/mikasalo_vaaka1102MN_503_vi.jpeg"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    it "not reply to a gif image from Iltalehti.fi" do
      uri = "http://static.iltalehti.fi/viihde/mikasalo_vaaka1102MN_503_vi.gif"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end

    it "not reply to a png image from Iltalehti.fi" do
      uri = "http://static.iltalehti.fi/viihde/mikasalo_vaaka1102MN_503_vi.png"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end

    it "reply to Iltasanomat.fi article" do
      uri = "http://www.iltasanomat.fi/hyvaolo/suhteet.asp?id=1822711"
      exp_result = "Koska flirtti puree naiseen? - Seksi ja parisuhde"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    it "reply to kauppalehti.fi pörssi article" do
      uri = "http://www.kauppalehti.fi/5/i/porssi/omaraha/uutiset.jsp?oid=20110782053"
      exp_result = "Janne Saarikko rakentamaan uutta finanssitaloa"
      expect(@bot).to receive(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
  end
end
