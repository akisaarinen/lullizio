require File.dirname(__FILE__) + '/test_helper.rb'
require 'modules/module_newstitle.rb'

class TestModule_Youtube < Test::Unit::TestCase
  context "Newstitle module" do
    setup do
      @bot = mock()
      @module = Module_Newstitle.new
      @module.init_module(@bot)
    end
    
    should "not reply to HS.fi article with title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/Kysely+Homoparien+vihkiminen+kirkossa+jakaa+kansan+mielipiteet/1135251596656"
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to HS.fi article without title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/1135251596656"
      exp_result = "Kysely: Homoparien vihkiminen kirkossa jakaa kansan mielipiteet"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end

    should "reply to HS.fi article from RSS without title in URL" do
      uri = "http://www.hs.fi/kotimaa/artikkeli/1135251596656?ref=rss"
      exp_result = "Kysely: Homoparien vihkiminen kirkossa jakaa kansan mielipiteet"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to Iltalehti.fi article" do
      uri = "http://www.iltalehti.fi/uutiset/2009121910813607_uu.shtml"
      exp_result = "Rekkajono Vaalimaalla pitenee | Uutiset"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end

    should "reply to Iltasanomat.fi article" do
      uri = "http://www.iltasanomat.fi/hyvaolo/suhteet.asp?id=1822711"
      exp_result = "Koska flirtti puree naiseen? - Seksi ja suhteet - Hyv\344 olo"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
    
    should "reply to mtv3.fi article" do
      uri = "http://www.mtv3.fi/uutiset/rikos.shtml/arkistot/rikos/2010/01/1045360"
      exp_result = "Humalainen konstaapeli ajoi lumipenkkaan anastamallaan poliisiautolla"
      @bot.expects(:send_privmsg).with("#channel", exp_result)
      @module.privmsg(@bot, "someone", "#channel", "some text with #{uri} inside")
    end
  end
end
