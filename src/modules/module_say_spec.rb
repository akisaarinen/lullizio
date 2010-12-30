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
  
  it "invokes say with Kernel#system" do
    @m.expects(:system).with("say \"huamn says test\"").once
    @m.privmsg(@bot, "huamn", "#channel", "test")
  end

  it "drops unwanted characters from input" do
    @m.expects(:speak).with("huamn says cleaned, input with åäöÅÄÖ!").once
    @m.privmsg(@bot, "huamn", "#channel", "\"cleaned, [input]** with åäöÅÄÖ!\"")
  end

  it "converts tj" do
    @m.expects(:speak).with("huamn says chief executive officer tjtj chief executive officer tjtj chief executive officer").once
    @m.privmsg(@bot, "huamn", "#channel", "Tj tjtj TJ tjtj tj")
  end
end


