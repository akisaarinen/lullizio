# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'module_handler'

class Module_First 
end
class Module_Second 
end

class TestModuleHandler < Test::Unit::TestCase
  def setup
    @bot = mock()
  end

  context "ModuleHandler" do
    setup do
      @handler = ModuleHandler.new
    end

    should "reload zero modules if none is found" do 
      dir = mock()
      dir.stubs(:entries).returns([])
      Dir.stubs(:new).returns(dir)
      @handler.reload(@bot, "modules_dir", [])
      assert_equal [], @handler.modules
    end

    should "load all found modules except excluded and pass on privmsgs" do 
      dir = mock()
      firstModule = mock()
      secondModule = mock()
      dir.stubs(:entries).returns(["module_first.rb", "module_excluded.rb", "module_second.rb"])
      Dir.stubs(:new).returns(dir)
      Kernel.expects(:load).with("modules_dir/module_first.rb")
      Kernel.expects(:load).with("modules_dir/module_second.rb")
      Module_First.stubs(:new).returns(firstModule)
      Module_Second.stubs(:new).returns(secondModule)
      firstModule.expects(:init_module).with(@bot)
      secondModule.expects(:init_module).with(@bot)
      @handler.reload(@bot, "modules_dir", ["excluded"])
      assert_equal [firstModule, secondModule], @handler.modules
    end
  end
  
  context "ModuleHandler with one loaded module" do
    setup do
      @handler = ModuleHandler.new
      dir = mock()
      @firstModule = mock()
      dir.stubs(:entries).returns(["module_first.rb"])
      Dir.stubs(:new).returns(dir)
      Kernel.expects(:load).with("modules_dir/module_first.rb")
      Module_First.stubs(:new).returns(@firstModule)
      @firstModule.expects(:init_module).with(@bot)
      @handler.reload(@bot, "modules_dir", [])
      assert_equal [@firstModule], @handler.modules
    end

    should "provide reply_to as channel when targeting a channel" do 
      @bot.expects(:nick).returns("bot_nick")
      @firstModule.expects(:privmsg).with(@bot, "someone", "#channel", "message")
      @handler.handle_privmsg("someone", "#channel", "message")
    end

    should "provide reply_to as sender when targeting the bot" do 
      @bot.expects(:nick).returns("bot_nick")
      @firstModule.expects(:privmsg).with(@bot, "someone", "someone", "message")
      @handler.handle_privmsg("someone", "bot_nick", "message")
    end
  end
end
