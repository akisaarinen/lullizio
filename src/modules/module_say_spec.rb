require 'rubygems'
require 'mocha'
require 'rspec'
require 'module_say'

describe Module_Say, "#privmsg" do

  before(:each) do
    @bot = mock('bot')
    @m = Module_Say.new
    @m.init_module(@bot)
  end

  it "always invokes system call" do
    @m.expects(:system).once
    @m.privmsg(@bot, "huamn", "#channel", "")
  end
end


