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
  end
end
