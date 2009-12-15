require "socket"

class MsgType
  NO_MSG = 0
  DISCONNECTED = 1
  PING = 2
  PRIVMSG = 3
  UNHANDLED = 4
end

class IrcMsg
  attr_accessor :msg_type
  def initialize(msg_type)
    @msg_type = msg_type
  end
end

class PrivMsg < IrcMsg
  attr_accessor :from, :target, :text
  def initialize(from, target, text)
    super(MsgType::PRIVMSG)
    @from = from
    @target = target
    @text = text
  end
end

class UnhandledMsg < IrcMsg
  attr_accessor :raw_msg
  def initialize(raw_msg) 
    super(MsgType::UNHANDLED) 
    @raw_msg = raw_msg
  end
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

  def read_input
    ready = IO.select([@ircsocket], nil, nil, nil)
    return IrcMsg.new(MsgType::NO_MSG) if !ready
    for s in ready[0]
      if s == @ircsocket then
        return IrcMsg.new(MsgType::DISCONNECTED) if @ircsocket.eof
        s = @ircsocket.gets
        handle_server_input(s)
      end
    end
  end

  def handle_server_input(s)
    case s.strip
      when /^PING :(.+)$/i
        send "PONG :#{$1}"
        return IrcMsg.new(MsgType::PING)

      when /^:([^ ]+?)!([^ ]+?)@([^ ]+?)\sPRIVMSG\s([^ ]+)\s:(.*)$/i
        from = $1
        target = $4
        text = $5
        return PrivMsg.new(from, target, text)

      else
        return UnhandledMsg.new(s)
    end
  end
end
