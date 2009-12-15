class Module_Lmgtfy
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    if msg =~ /^(.*(:|,) )?g (.*)$/
      querystr = $3.split(" ").join("%20")
      bot.send_privmsg(reply_to, "#{$1}http://lmgtfy.com/?q=#{querystr}")
    end
  end
end

