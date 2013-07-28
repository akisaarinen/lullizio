# -*- encoding : utf-8 -*-
require "rubygems"
require 'bundler/setup'
require "yaml"

require_relative "irc_connector"
require_relative "module_handler"

YAML::ENGINE.yamler = 'syck'

class Bot
  attr_accessor :nick, :connected, :base_path, :module_config

  def initialize(config_file, module_handler)
    @config_file = config_file
    @module_handler = module_handler
    @connected = false
    @own_msgs = []
    reload_config
  end
  
  def connect
    @connector = create_connector(@server, @port, @nick, @username, @realname, @channels)
    @connector.connect
    @connected = true
  end

  def handle_state
    connect if @connected == false
    msg = @connector.read_input
    case msg.msg_type
      when IrcMsg::DISCONNECTED
        @connected = false

      when IrcMsg::UNHANDLED
        puts "<-- #{msg.raw_msg}"

      when IrcMsg::PRIVMSG
        if msg.text == "!reload"
          reload_config
        else
          @module_handler.handle_privmsg(msg.from, msg.target, msg.text)
        end
      
        @own_msgs.each { |m| 
            @module_handler.handle_botmsg(m["target"], m["msg"])
        }
        @own_msgs = []
      else
    end
  end

  def send_raw(msg) @connector.send(msg) end
  def send_privmsg(target, msg) 
      @connector.privmsg(target, msg) 
      @own_msgs.push({ "target" => target, "msg" => msg })
  end

  private

  def reload_config
    config = YAML.load_file(@config_file)

    @server = config["server"]
    @port = config["port"]
    @nick = config["nick"]
    @username = config["username"]
    @realname = config["realname"]
    @channels = config["channels"]
    @modules_dir = config["modules_dir"]
    @excluded_modules = config["excluded_modules"]
    @module_config = config["module_config"]
    $LOAD_PATH << @modules_dir

    @module_handler.reload(self, @modules_dir, @excluded_modules)
  end
  

  def create_connector(server, port, nick, username, realname, channels)
    IrcConnector.new(server, port, nick, username, realname, channels)
  end
end
