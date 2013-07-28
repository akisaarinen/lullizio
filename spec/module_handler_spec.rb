# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'module_handler'

class Module_First 
end
class Module_Second 
end

describe 'ModuleHandler' do
  before(:each) do
    @bot = double()
  end

  context "ModuleHandler" do
    before(:each) do
      @handler = ModuleHandler.new
    end

    it "reload zero modules if none is found" do 
      dir = double()
      expect(dir).to receive(:entries).and_return([])
      expect(Dir).to receive(:new).and_return(dir)
      @handler.reload(@bot, "modules_dir", [])
      expect(@handler.modules).to eq([])
    end

    it "load all found modules except excluded and pass on privmsgs" do 
      dir = double()
      firstModule = double()
      secondModule = double()
      expect(dir).to receive(:entries).and_return(["module_first.rb", "module_excluded.rb", "module_second.rb"])
      expect(Dir).to receive(:new).and_return(dir)
      expect(Kernel).to receive(:load).with("modules_dir/module_first.rb")
      expect(Kernel).to receive(:load).with("modules_dir/module_second.rb")
      expect(Module_First).to receive(:new).and_return(firstModule)
      expect(Module_Second).to receive(:new).and_return(secondModule)
      expect(firstModule).to receive(:init_module).with(@bot)
      expect(secondModule).to receive(:init_module).with(@bot)
      @handler.reload(@bot, "modules_dir", ["excluded"])
	  expect(@handler.modules).to eq([firstModule, secondModule])
    end
  end
  
  context "ModuleHandler with one loaded module" do
    before(:each) do
      @handler = ModuleHandler.new
      dir = double()
      @firstModule = double()
      expect(dir).to receive(:entries).and_return(["module_first.rb"])
      expect(Dir).to receive(:new).and_return(dir)
      expect(Kernel).to receive(:load).with("modules_dir/module_first.rb")
      expect(Module_First).to receive(:new).and_return(@firstModule)
      expect(@firstModule).to receive(:init_module).with(@bot)
      @handler.reload(@bot, "modules_dir", [])
	  expect(@handler.modules).to eq([@firstModule])
    end

    it "provide reply_to as channel when targeting a channel" do 
      expect(@bot).to receive(:nick).and_return("bot_nick")
      expect(@firstModule).to receive(:privmsg).with(@bot, "someone", "#channel", "message")
      @handler.handle_privmsg("someone", "#channel", "message")
    end

    it "provide reply_to as sender when targeting the bot" do 
      expect(@bot).to receive(:nick).and_return("bot_nick")
      expect(@firstModule).to receive(:privmsg).with(@bot, "someone", "someone", "message")
      @handler.handle_privmsg("someone", "bot_nick", "message")
    end
  end
end
