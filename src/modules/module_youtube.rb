Kernel.load("youtube.rb")

class Module_Youtube
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /youtube.com\/watch?/
        youtube_title = parseYoutube(word)
        bot.send_privmsg(reply_to, youtube_title)
      end
    }
  end
end

