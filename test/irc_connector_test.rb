require File.dirname(__FILE__) + '/test_helper.rb'
require 'irc_connector'

class TestIrcConnector < Test::Unit::TestCase
  context "Disconnected connector" do
    setup do
      @socket = mock()
      @connector = IrcConnector.new("server", 6667, "nick", "username", "real name", ["#first", "#second"])
      @connector.stubs(:create_socket).returns(@socket)
    end

    should "register to irc server and join channels on connect" do
      @socket.expects(:send).with("USER username username username :real name\n", 0)
      @socket.expects(:send).with("NICK nick\n", 0)
      @socket.expects(:send).with("JOIN #second\n", 0)
      @socket.expects(:send).with("JOIN #first\n", 0)
      @connector.connect
    end
  end

  context "Connected connector" do
    setup do
      @socket = mock()
      @connector = IrcConnector.new("server", 6667, "nick", "username", "real name", ["#first", "#second"])
      @connector.set_socket(@socket)
    end

    should "remove additional line changes when sending" do
      @socket.expects(:send).with("message with line feeds removed\n", 0)
      @connector.send("message \nwith\r \nline\r\n feeds removed\r\n\n")
    end

    should "send privmsg" do 
      @socket.expects(:send).with("PRIVMSG target :hello, world\n", 0)
      @connector.privmsg("target", "hello, world")
    end

    should "reply with pong to ping" do
      @socket.expects(:send).with("PONG :12345\n", 0)
      msg = @connector.handle_server_input("PING :12345")
      assert_equal MsgType::PING, msg.msg_type
    end

    should "handle unexpected input" do 
      msg = @connector.handle_server_input("SOME MESSAGE :from irc server that is invalid")
      assert_equal MsgType::UNHANDLED, msg.msg_type
    end
  end
end
