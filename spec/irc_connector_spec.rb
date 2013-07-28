# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'irc_connector'

describe "Disconnected connector" do
  before(:each) do
	@socket = double()
	@connector = IrcConnector.new("server", 6667, "nick", "username", "real name", ["#first", "#second"])
	expect(@connector).to receive(:create_socket).and_return(@socket)
  end

  it "register to irc server and join channels on connect" do
	expect(@socket).to receive(:send).with("USER username username username :real name\n", 0)
	expect(@socket).to receive(:send).with("NICK nick\n", 0)
	expect(@socket).to receive(:send).with("JOIN #second\n", 0)
	expect(@socket).to receive(:send).with("JOIN #first\n", 0)
	@connector.connect
  end
end

describe "Connected connector" do
  before(:each) do
	@socket = double()
	@connector = IrcConnector.new("server", 6667, "nick", "username", "real name", ["#first", "#second"])
	@connector.set_socket(@socket)
  end

  it "remove additional line changes when sending" do
	expect(@socket).to receive(:send).with("message with line feeds removed\n", 0)
	@connector.send("message \nwith\r \nline\r\n feeds removed\r\n\n")
  end

  it "send privmsg" do 
	expect(@socket).to receive(:send).with("PRIVMSG target :hello, world\n", 0)
	@connector.privmsg("target", "hello, world")
  end

  it "reply with pong to ping" do
	expect(@socket).to receive(:send).with("PONG :12345\n", 0)
	msg = @connector.handle_server_input("PING :12345")
	expect(msg.msg_type).to eq(IrcMsg::PING)
  end

  it "detect privmsg to channel" do 
	privmsg = ":nickname!username@some.source.host PRIVMSG #channel :text and more text"
	msg = @connector.handle_server_input(privmsg)
	expect(msg.msg_type).to eq(IrcMsg::PRIVMSG)
	expect(msg.from).to eq("nickname")
	expect(msg.target).to eq("#channel")
	expect(msg.text).to eq("text and more text")
  end

  it "detect privmsg to individual user" do 
	privmsg = ":nickname!username@some.source.host PRIVMSG target_nick :text and more text"
	msg = @connector.handle_server_input(privmsg)
	expect(msg.msg_type).to eq(IrcMsg::PRIVMSG)
	expect(msg.from).to eq("nickname")
	expect(msg.target).to eq("target_nick")
	expect(msg.text).to eq("text and more text")
  end

  it "handle unexpected input" do 
	raw_msg = "SOME MESSAGE :from irc server that is invalid"
	msg = @connector.handle_server_input(raw_msg)
	expect(msg.msg_type).to eq(IrcMsg::UNHANDLED)
	expect(msg.raw_msg).to eq(raw_msg)
  end

  it "detect that there are no new messages when select returns nil" do
	expect(IO).to receive(:select).and_return(nil)
	msg = @connector.read_input
	expect(msg.msg_type).to eq(IrcMsg::NO_MSG)
  end

  it "detect that there are no new messages when select returns empty list" do
	expect(IO).to receive(:select).and_return([[]])
	msg = @connector.read_input
	expect(msg.msg_type).to eq(IrcMsg::NO_MSG)
  end

  it "detect disconnection" do
	ready = [[@socket]]
	expect(IO).to receive(:select).and_return(ready)
	expect(@socket).to receive(:eof).and_return(true)
	msg = @connector.read_input
	expect(msg.msg_type).to eq(IrcMsg::DISCONNECTED)
  end

  it "handle message" do
	expect(@connector).to receive(:handle_server_input).with("a message")
	ready = [[@socket]]
	expect(IO).to receive(:select).and_return(ready)
	expect(@socket).to receive(:eof).and_return(false)
	expect(@socket).to receive(:gets).and_return("a message")
	@connector.read_input
  end
end
