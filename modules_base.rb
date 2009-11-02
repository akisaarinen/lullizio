#!/usr/local/bin/ruby

class Bot
  def modules_reload
    @modules.each { |m|
      begin
        Kernel.load("module_#{m}.rb")
      rescue Exception => e
        puts "Error registering module #{m}: #{e.message}"
        print e.backtrace.join("\n")
      end
    }
  end

  def modules_privmsg(reply_to, msg)
    @modules.each { |m|
      begin
        name = "#{m}_privmsg"
        method(name).call(self, reply_to, msg)
      rescue NoMethodError => nme
      rescue Exception => e
        puts "Error calling privmsg for #{m}: #{e.message}"
        print e.backtrace.join("\n")
      end
    }
  end
end
