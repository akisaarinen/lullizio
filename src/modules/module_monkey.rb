require "yaml"

class Module_Monkey
  def init_module(bot)
    filename = bot.module_config["monkey_file"]
    cfg_file = bot.base_path + "/" + filename
    puts "Reading monkey config from '#{cfg_file}'"
    @expressions = YAML.load_file(cfg_file)
    puts "Read"
  end

  def privmsg(bot, from, reply_to, msg)
    @expressions.value.each { |expr|
      expr.each { |trigger, reply| 
        puts "trig"
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
end

