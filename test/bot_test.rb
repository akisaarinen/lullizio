require File.dirname(__FILE__) + '/test_helper.rb'
require 'bot'

class TestBot < Test::Unit::TestCase
  def setup 
    @config = {
      "server" => "server",
      "port" => 6667,
      "nick" => "nick",
      "username" => "username",
      "realname" => "realname",
      "channels" => ["#first", "#second"],
      "modules_dir" => "modules_dir",
      "module_config" => []
    }
    @base_path = "base_path"
    @config_path = "path/to/config_file.yml"
    YAML.stubs(:load_file).with(@config_path).returns(@config)
    @module_handler = mock()
    @module_handler.expects(:reload)
  end
  
  context "Bot" do
    setup do
      @bot = Bot.new(@base_path, @config_path, @module_handler)
    end

    should "load nickname from config in initialization" do 
      assert_equal "nick", @bot.nick
    end

    should "add modules dir with base path to $LOAD_PATH" do
      assert $LOAD_PATH.include?("base_path/modules_dir")
    end
  end

  context "Disconnected Bot" do
    setup do
      @connector = mock()
      @bot = Bot.new(@base_path, @config_path, @module_handler)
      @bot.stubs(:create_connector).
          with("server", 6667, "nick", "username", "realname", ["#first", "#second"]).
          returns(@connector)
    end
    should "connect" do 
      @connector.expects(:connect).returns(nil)
      @bot.connect
      assert_equal true, @bot.connected
    end
    should "raise exception" do
      @connector.expects(:connect).raises(Exception)
      assert_raise Exception do
        @bot.connect
      end
    end
    should "attempt reconnection and then read input" do
      @connector.expects(:connect)
      @connector.expects(:read_input).returns(IrcMsg.new(IrcMsg::NO_MSG))
      @bot.handle_state
    end
  end
  
  context "Connected Bot" do
    setup do
      @connector = mock()
      @bot = Bot.new(@base_path, @config_path, @module_handler)
      @bot.stubs(:create_connector).returns(@connector)
      @connector.stubs(:connect)
      @bot.connect
    end

    should "send raw msg" do
      @connector.expects(:send).with("a raw message")
      @bot.send_raw("a raw message")
    end

    should "send privmsg" do 
      @connector.expects(:privmsg).with("target", "message body")
      @bot.send_privmsg("target", "message body")
    end

    should "disconnect when receiving disconnect message" do 
      @connector.expects(:read_input).returns(IrcMsg.new(IrcMsg::DISCONNECTED))
      @bot.handle_state
      assert_equal false, @bot.connected
    end

    should "print unhandled message" do
      @bot.expects(:puts).with("<-- some unknown text").returns(nil)
      @connector.expects(:read_input).returns(UnhandledMsg.new("some unknown text"))
      @bot.handle_state
    end

    should "give handling of privmsg to module handler" do
      msg = PrivMsg.new("from", "target", "text")
      @connector.expects(:read_input).returns(msg)
      @module_handler.expects(:handle_privmsg).with("from", "target", "text")
      @bot.handle_state
    end

    should "reload configuration on request" do
      msg = PrivMsg.new("from", "target", "!reload")
      @connector.expects(:read_input).returns(msg)
      @bot.expects(:reload_config)
      @bot.handle_state
    end
  end
end
