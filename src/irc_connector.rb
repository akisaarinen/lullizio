require "socket"

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
end
