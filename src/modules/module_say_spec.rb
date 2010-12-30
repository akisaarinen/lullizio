require 'rubygems'
require 'mocha'
require 'rspec'
require 'module_say'

describe Module_Say do

  before(:each) do
    @bot = mock('bot')
    @m = Module_Say.new
    @m.init_module(@bot)
  end

  it "does nothing with empty privmsg" do
    @m.expects(:speak).never
    @m.privmsg(@bot, "huamn", "#channel", "")
  end
  
  it "does nothing with empty botmsg" do
    @m.expects(:speak).never
    @m.botmsg(@bot, "#channel", "")
  end
  
  it "invokes say with Kernel#system using Ralph for bot" do
    @m.expects(:system).with("say -v \"Ralph\" \"I say test\"").once
    @m.botmsg(@bot, "#channel", "test")
  end
  
  it "invokes say with Kernel#system using Princess for huamn" do
    @m.expects(:system).with("say -v \"Ralph\" \"huamn says\"").once
    @m.expects(:system).with("say -v \"Princess\" \"test\"").once
    @m.privmsg(@bot, "huamn", "#channel", "test")
  end
  
  it "invokes say with Kernel#system using Junior for Pantti" do
    @m.expects(:system).with("say -v \"Ralph\" \"Pantti says\"").once
    @m.expects(:system).with("say -v \"Junior\" \"test\"").once
    @m.privmsg(@bot, "Pantti", "#channel", "test")
  end
  
  it "drops unwanted characters from input" do
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "cleaned, input with åäöÅÄÖ!").once
    @m.privmsg(@bot, "huamn", "#channel", "\"cleaned, [input]** with åäöÅÄÖ!\"")
  end

  it "converts tj" do
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "chief executive officer tjtj chief executive officer tjtj chief executive officer").once
    @m.privmsg(@bot, "huamn", "#channel", "Tj tjtj TJ tjtj tj")
  end

  it "converts ap" do
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "yrro mi paysa").once
    @m.privmsg(@bot, "huamn", "#channel", "ap")
  end
  
  it "strips urls" do
    @m.expects(:speak).with(nil, "huamn says").once
    @m.expects(:speak).with("huamn", "heh smiley").once
    @m.privmsg(@bot, "huamn", "#channel", "http://www.youtube.com/watch?v=kQFKtI6gn9Y heh :)")
  end
end


