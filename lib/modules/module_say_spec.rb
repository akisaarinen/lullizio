# -*- encoding : utf-8 -*-
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
    seq = sequence('seq')
    @m.expects(:system).with("say -v \"Ralph\" \"huamn says\"").once
    @m.expects(:system).with("say -v \"Princess\" \"test\"").once
    @m.privmsg(@bot, "huamn", "#channel", "test")
  end
  
  def test_invokes_say_with_Kernel_system_using_Junior_for_Pantti
    seq = sequence('seq')
    @m.expects(:system).with("say -v \"Ralph\" \"Pantti says\"").once.in_sequence(seq)
    @m.expects(:system).with("say -v \"Junior\" \"test\"").once.in_sequence(seq)
    @m.privmsg(@bot, "Pantti", "#channel", "test")
  end
  
  def test_drops_unwanted_characters_from_input
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "cleaned, input with åäöÅÄÖ 1 2 3!").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "\"cleaned, [input]** with åäöÅÄÖ 1 2 3!\"")
  end

  def test_converts_tj
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "chief executive officer tjtj chief executive officer tjtj chief executive officer").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "Tj tjtj TJ tjtj tj")
  end

  def test_converts_ap
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "yrro mi paysa").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "ap")
  end
  
  def test_strips_urls_and_comments_them_separately
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn posts an url to boobs").once.in_sequence(seq)
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "heh smiley").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "http://www.youtube.com/watch?v=kQFKtI6gn9Y heh :)")
  end
  
  def test_rickrolls
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "I like rick").once.in_sequence(seq)
    @m.expects(:say).with("Cellos", "huamn I'm never gonna give you up, never gonna let you down!").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "I like rick")
  end
  
  def test_pig
    seq = sequence('seq')
    @m.expects(:speak).with(nil, "huamn says").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "pig").once.in_sequence(seq)
    @m.expects(:speak).with(nil, "huamn would also like to announce the following").once.in_sequence(seq)
    @m.expects(:speak).with("huamn", "ar ar ar niff niff niff i am a pig").once.in_sequence(seq)
    @m.privmsg(@bot, "huamn", "#channel", "pig")
  end
end

