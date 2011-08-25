require 'htmlentities'

Kernel.load("fetch_uri.rb")

class Module_Nhl
  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^nhl|^[\344]n[\344]ri|^änäri/
        bot.send_privmsg(reply_to, "Enää #{time_until_nhl} päivää!!1")
      end
    }
  end

  def botmsg(bot,target,msg) end

  private

  def time_until_nhl
    nhl = Time.local(2011,9,9)
    diff = nhl - time_now
    (diff / 3600 / 24).ceil
  end

  def time_now
    Time.now
  end
end

