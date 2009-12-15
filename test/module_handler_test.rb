require File.dirname(__FILE__) + '/test_helper.rb'
require 'module_handler'

class Firstmodule 
end
class Secondmodule 
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
      dir.stubs(:entries).returns(["module_firstmodule.rb", "module_excluded.rb", "module_secondmodule.rb"])
      Dir.stubs(:new).returns(dir)
      Kernel.expects(:load).with("modules_dir/module_firstmodule.rb")
      Kernel.expects(:load).with("modules_dir/module_secondmodule.rb")
      Firstmodule.stubs(:new).returns(firstModule)
      Secondmodule.stubs(:new).returns(secondModule)
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
      dir.stubs(:entries).returns(["module_firstmodule.rb"])
      Dir.stubs(:new).returns(dir)
      Kernel.expects(:load).with("modules_dir/module_firstmodule.rb")
      Firstmodule.stubs(:new).returns(@firstModule)
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
