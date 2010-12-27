class Module_Say
  def init_module(bot) 
  end
  
  def privmsg(bot, from, reply_to, msg)
      system "say \"#{from} says #{msg}\""
  end
  
  def botmsg(bot, target, msg)
      system "say \"I say #{msg}\""
  end
end
