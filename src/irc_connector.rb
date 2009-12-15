require "socket"

class MsgType
  PING = 1
  UNHANDLED = 2
end

class IrcMsg
  attr_accessor :msg_type
  def initialize(msg_type)
    @msg_type = msg_type
  end
end

class PingMsg < IrcMsg
  def initialize() super(MsgType::PING) end
end

class UnhandledMsg < IrcMsg
  def initialize() super(MsgType::UNHANDLED) end
end

class IrcConnector
  def initialize(server, port, nick, username, realname, channels)
    @server = server
    @port = port
    @nick = nick
    @username = username
    @realname = realname
    @channels = channels
  end

  def set_socket(socket)
    @ircsocket = socket
  end
  
  def create_socket(server, port)
    TCPSocket.open(server, port)
  end

  def send(s)
    s = s.gsub(/\n/, '')
    s = s.gsub(/\r/, '')
    @ircsocket.send("#{s}\n", 0)
  end

  def connect()
    set_socket(create_socket(@server, @port))
    send "USER #{@username} #{@username} #{@username} :#{@realname}"
    send "NICK #{@nick}"
    @channels.each { |channel|
      send "JOIN #{channel}"
    }
  end

  def privmsg(target, msg)
    send "PRIVMSG #{target} :#{msg}"
  end

  def handle_server_input(s)
    case s.strip
      when /^PING :(.+)$/i
        send "PONG :#{$1}"
        return PingMsg.new
      else
        puts "<-- #{s}"
        return UnhandledMsg.new
    end
  end
end
