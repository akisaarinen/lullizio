class Bot
  def lmgtfy_privmsg(bot, from, reply_to, msg)
    if msg =~ /^(.*(:|,) )?g (.*)$/
      querystr = $3.split(" ").join("%20")
      bot.privmsg(reply_to, "#{$1}http://lmgtfy.com/?q=#{querystr}")
    end
  end
end

