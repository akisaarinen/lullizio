$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "modules_base"
require "irc_connector"
require "yaml"

class Bot
  attr_accessor :nick, :connected

  def initialize(base_path, config_file, module_handler)
    @base_path = base_path
    @config_file = config_file
    @module_handler = module_handler
    @connected = false
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
        @module_handler.handle_privmsg(msg.from, msg.target, msg.text)

      else
    end
  end

  def send_raw(msg) @connector.send(msg) end
  def send_privmsg(target, msg) @connector.privmsg(target, msg) end

  private

  def reload_config
    config = YAML.load_file(@config_file)

    @server = config["server"]
    @port = config["port"]
    @nick = config["nick"]
    @username = config["username"]
    @realname = config["realname"]
    @channels = config["channels"]
    @modules_dir = @base_path + "/" + config["modules_dir"]
    @excluded_modules = config["excluded_modules"]
    @module_config = config["module_config"]
    $LOAD_PATH << @modules_dir
  end

  def create_connector(server, port, nick, username, realname, channels)
    IrcConnector.new(server, port, nick, username, realname, channels)
  end
end
