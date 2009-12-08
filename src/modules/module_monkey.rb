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
    @expressions = YAML.load_file(base_path + "/" + filename)["expressions"]
  end

  def privmsg(bot, from, reply_to, msg)
    @expressions.each { |trigger, reply|
      if m = Regexp.new(trigger).match(msg)
        (m.length - 1).times.map { |i| i + 1 }.each { |i|
          reply.gsub!("{#{i}}", m[i])
        }
        bot.privmsg(reply_to, reply)
      end
    }
  end
end
