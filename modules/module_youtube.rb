#!/usr/local/bin/ruby

Kernel.load("youtube.rb")

class Bot
  def youtube_privmsg(bot, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /.*youtube.com\/watch?/
        youtube_title = parseYoutube(word)
        bot.privmsg(reply_to, youtube_title)
      end
    }
  end
end

