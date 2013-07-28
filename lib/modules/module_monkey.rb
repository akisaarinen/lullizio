# -*- encoding : utf-8 -*-
require "yaml"

class Module_Monkey
  def init_module(bot)
    filename = bot.module_config["monkey_file"]
    puts "Reading monkey config from '#{filename}'"
    @expressions = YAML.load_file(filename)
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
          bot.send_privmsg(reply_to, updated_reply)
          return
        end
      }
    }
  end
  def botmsg(bot,target,msg) end
end

