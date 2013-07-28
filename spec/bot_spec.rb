# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'bot'

describe "TestBot" do
  before(:each) do
    @config = {
      "server" => "server",
      "port" => 6667,
      "nick" => "nick",
      "username" => "username",
      "realname" => "realname",
      "channels" => ["#first", "#second"],
      "modules_dir" => "modules_dir",
      "module_config" => {"some key" => "some value"}
    }
    @config_path = "path/to/config_file.yml"
    expect(YAML).to receive(:load_file).with(@config_path).and_return(@config)
    @module_handler = double()
	expect(@module_handler).to receive(:reload)
  end
  
  context "Bot" do
	before (:each) do
	  @bot = Bot.new(@config_path, @module_handler)
	end

    it "load nickname from config in initialization" do 
	  expect(@bot.nick).to eq("nick")
    end

    it "give module specific configuration" do 
      expect(@bot.module_config).to eq(({"some key" => "some value"}))
    end

    it "add modules dir to $LOAD_PATH" do
      expect($LOAD_PATH.include?("modules_dir")).to eq(true)
    end
  end

  context "Disconnected Bot" do
	before(:each) do
	  @connector = double()
	  @bot = Bot.new(@config_path, @module_handler)
	  expect(@bot).to receive(:create_connector).
		  with("server", 6667, "nick", "username", "realname", ["#first", "#second"]).
		  and_return(@connector)
	end

    it "connect" do 
      expect(@connector).to receive(:connect).and_return(nil)
      @bot.connect
      expect(@bot.connected).to eq(true)
    end

    it "raise exception" do
      expect(@connector).to receive(:connect).and_throw(Exception)
	  expect { @bot.connect }.to raise_error(Exception)
    end
    it "attempt reconnection and then read input" do
      expect(@connector).to receive(:connect)
      expect(@connector).to receive(:read_input).and_return(IrcMsg.new(IrcMsg::NO_MSG))
      @bot.handle_state
    end
  end
  
  context "Connected Bot" do
	before(:each) do
	  @connector = double()
	  @bot = Bot.new(@config_path, @module_handler)
	  expect(@bot).to receive(:create_connector).and_return(@connector)
	  expect(@connector).to receive(:connect)
	  @bot.connect
	end

    it "send raw msg" do
      expect(@connector).to receive(:send).with("a raw message")
      @bot.send_raw("a raw message")
    end

    it "send privmsg" do 
      expect(@connector).to receive(:privmsg).with("target", "message body")
      @bot.send_privmsg("target", "message body")
    end

    it "disconnect when receiving disconnect message" do 
      expect(@connector).to receive(:read_input).and_return(IrcMsg.new(IrcMsg::DISCONNECTED))
      @bot.handle_state
      expect(@bot.connected).to eq(false)
    end

    it "print unhandled message" do
      expect(@bot).to receive(:puts).with("<-- some unknown text").and_return(nil)
      expect(@connector).to receive(:read_input).and_return(UnhandledMsg.new("some unknown text"))
      @bot.handle_state
    end

    it "give handling of privmsg to module handler" do
      msg = PrivMsg.new("from", "target", "text")
      expect(@connector).to receive(:read_input).and_return(msg)
      expect(@module_handler).to receive(:handle_privmsg).with("from", "target", "text")
      @bot.handle_state
    end

    it "reload configuration on request" do
      msg = PrivMsg.new("from", "target", "!reload")
      expect(@connector).to receive(:read_input).and_return(msg)
      expect(@bot).to receive(:reload_config)
      @bot.handle_state
    end
  end
end
