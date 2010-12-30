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
    @m.expects(:system).never
    @m.privmsg(@bot, "huamn", "#channel", "")
  end
  
  it "does nothing with empty botmsg" do
    @m.expects(:system).never
    @m.botmsg(@bot, "#channel", "")
  end
end


