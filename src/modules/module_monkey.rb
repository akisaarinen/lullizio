require "yaml"

class Bot
  def monkey_initialize(bot)
    @monkey = Monkey.new(@base_path, @module_config["monkey_file"])
  end
  def monkey_privmsg(bot, from, reply_to, msg)
    @monkey.privmsg(bot, from, reply_to, msg)
  end
end

class Monkey
  def initialize(base_path, filename)
    cfg_file = base_path + "/" + filename
    puts "Reading monkey config from '#{cfg_file}'"
    @expressions = YAML.load_file(cfg_file)
  end

  def privmsg(bot, from, reply_to, msg)
    @expressions.value.each { |expr|
      expr.each { |trigger, reply| 
        if m = Regexp.new(trigger).match(msg)
          updated_reply = reply.clone
          (m.length - 1).times.map { |i| i + 1 }.each { |i|
            begin
              updated_reply.gsub!("{#{i}}", m[i])
            rescue e
            end
          }
          updated_reply.gsub!("{from}", from)
          bot.privmsg(reply_to, updated_reply)
          return
        end
      }
    }
  end
end

