require 'rubygems'
require 'test/unit'
require 'module_say'
require 'mocha'

class ModuleSayTest < Test::Unit::TestCase

  def setup
    @bot = mock('bot')
    @m = Module_Say.new
    @m.init_module(@bot)
  end

  def test_does_nothing_with_empty_privmsg
    @m.expects(:speak).never
    @m.privmsg(@bot, "huamn", "#channel", "")
  end
  
  def test_does_nothing_with_empty_botmsg
    @m.expects(:speak).never
    @m.botmsg(@bot, "#channel", "")
  end
  
  def test_invokes_say_with_Kernel_system_using_Ralph_for_bot
    @m.expects(:system).with("say -v \"Ralph\" \"I say test\"").once
    @m.botmsg(@bot, "#channel", "test")
  end
  
  def test_invokes_say_with_Kernel_system_using_Princess_for_huamn
    @m.expects(:system).with("say -v \"Ralph\" \"huamn says\"").once
    @m.expects(:system).with("say -v \"Princess\" \"test\"").once
    @m.privmsg(@bot, "huamn", "#channel", "test")
  end
  
  def test_invokes_say_with_Kernel_system_using_Junior_for_Pantti
    @m.expects(:system).with("say -v \"Ralph\" \"Pantti says\"").once
    @m.expects(:system).with("say -v \"Junior\" \"test\"").once
    @m.privmsg(@bot, "Pantti", "#channel", "test")
  end
  
  def test_drops_unwanted_characters_from_input
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "cleaned, input with åäöÅÄÖ!").once
    @m.privmsg(@bot, "huamn", "#channel", "\"cleaned, [input]** with åäöÅÄÖ!\"")
  end

  def test_converts_tj
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "chief executive officer tjtj chief executive officer tjtj chief executive officer").once
    @m.privmsg(@bot, "huamn", "#channel", "Tj tjtj TJ tjtj tj")
  end

  def test_converts_ap
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "yrro mi paysa").once
    @m.privmsg(@bot, "huamn", "#channel", "ap")
  end
  
  def test_strips_urls
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "heh smiley").once
    @m.privmsg(@bot, "huamn", "#channel", "http://www.youtube.com/watch?v=kQFKtI6gn9Y heh :)")
  end
end

