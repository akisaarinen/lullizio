require "socket"
require "modules_base"
require "yaml"

class Bot
  def initialize(base_path, config_file)
    @base_path = base_path
    @config_file = config_file
    reload_config
  end
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
  end
  def send(s)
    s = s.gsub /\n/, ''
    s = s.gsub /\r/, ''
    puts "--> #{s}"
    @ircsocket.send "#{s}\n", 0
  end
  def privmsg(target, msg)
    send "PRIVMSG #{target} :#{msg}"
  end
  def connect()
    puts "Connecting to #{@server}:#{@port}"

    @ircsocket = TCPSocket.open(@server, @port)
    send "USER #{@username} #{@username} #{@username} :#{@realname}"
    send "NICK #{@nick}"
    @channels.each { |channel|
      send "JOIN #{channel}"
    }
  end
  def handle_server_input(s)
    case s.strip
      when /^PING :(.+)$/i
        puts "[ Server ping ]"
        send "PONG :#{$1}"
      when /^:([^ ]+?)!([^ ]+?)@([^ ]+?)\sPRIVMSG\s([^ ]+)\s:(.*)$/i
        puts "<-- #{s}"
        from = $1
        target = $4
        msg = $5
          
        reply_to = (target == @nick) ? from : target

        if msg == "!reload"
          begin
            modules_reload
            privmsg(reply_to, "Reload OK")
          rescue Exception => e
            privmsg(reply_to, "Error: #{e.message}")
            puts "Error reloading: " + e.message()
            print e.backtrace.join("\n")
          end
        else
          modules_privmsg(from, reply_to, msg)
        end
      else
        puts "<-- #{s}"
    end
  end
  def main_loop()
    while true
      ready = select([@ircsocket, $stdin], nil, nil, nil)
      next if !ready
      for s in ready[0]
        if s == $stdin then
          return if $stdin.eof
          s = $stdin.gets
          send s
        elsif s == @ircsocket then
          return if @ircsocket.eof
          s = @ircsocket.gets
          handle_server_input(s)
        end
      end
    end
  end
end

base_path = ARGV.shift
config_file = base_path + "/" + (ARGV.shift || "config.yml")
bot = Bot.new(base_path, config_file)
bot.modules_reload()

bot.connect()
begin
  bot.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end
