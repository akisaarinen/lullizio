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

    should "detect privmsg to channel" do 
      privmsg = ":nickname!username@some.source.host PRIVMSG #channel :text and more text"
      msg = @connector.handle_server_input(privmsg)
      assert_equal MsgType::PRIVMSG, msg.msg_type
      assert_equal "nickname", msg.from
      assert_equal "#channel", msg.target
      assert_equal "text and more text", msg.text
    end

    should "detect privmsg to individual user" do 
      privmsg = ":nickname!username@some.source.host PRIVMSG target_nick :text and more text"
      msg = @connector.handle_server_input(privmsg)
      assert_equal MsgType::PRIVMSG, msg.msg_type
      assert_equal "nickname", msg.from
      assert_equal "target_nick", msg.target
      assert_equal "text and more text", msg.text
    end

    should "handle unexpected input" do 
      raw_msg = "SOME MESSAGE :from irc server that is invalid"
      msg = @connector.handle_server_input(raw_msg)
      assert_equal MsgType::UNHANDLED, msg.msg_type
      assert_equal raw_msg, msg.raw_msg
    end

    should "detect that there are no new messages" do
      IO.stubs(:select).returns(nil)
      msg = @connector.read_input
      assert_equal MsgType::NO_MSG, msg.msg_type
    end

    should "detect disconnection" do
      ready = [[@socket]]
      IO.stubs(:select).returns(ready)
      @socket.stubs(:eof).returns(true)
      msg = @connector.read_input
      assert_equal MsgType::DISCONNECTED, msg.msg_type
    end

    should "handle message" do
      @connector.expects(:handle_server_input).with("a message")
      ready = [[@socket]]
      IO.stubs(:select).returns(ready)
      @socket.stubs(:eof).returns(false)
      @socket.expects(:gets).returns("a message")
      @connector.read_input
    end
  end
end
