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
  end
  
  context "Bot" do
    setup do
      @bot = Bot.new(@base_path, @config_path)
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
      @bot = Bot.new(@base_path, @config_path)
      @bot.stubs(:create_connector).
          with("server", 6667, "nick", "username", "realname", ["#first", "#second"]).
          returns(@connector)
    end
    should "connect" do 
      @connector.expects(:connect).returns(nil)
      @bot.connect
    end
    should "raise exception" do
      @connector.expects(:connect).raises(Exception)
      assert_raise Exception do
        @bot.connect
      end
    end
  end
end
