class Module_Say
  def init_module(bot) 
  end
  
  def privmsg(bot, from, reply_to, msg)
      system "say \"#{from} says #{convert_input(msg)}\""
  end
  
  def botmsg(bot, target, msg)
      system "say \"I say #{convert_input(msg)}\""
  end

private
 
  def convert_input(s) 
      p s.scan(/./m)
      s.gsub(/:[)DdPpEe]/, " smiley ").
       gsub(":(", " sad face ").
       gsub("8-D", " dick ").
       gsub("="," equals ").
       gsub("\345","å").
       gsub("\344","ä").
       gsub("\366","ö").
       gsub("\305","Å").
       gsub("\304","Ä").
       gsub("\326","Ö").
       gsub(/[^a-zA-ZåäöÅÄÖ]/u,"")
  end
end
