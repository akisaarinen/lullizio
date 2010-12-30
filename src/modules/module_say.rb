class Module_Say
  def init_module(bot) 
  end
  
  def privmsg(bot, from, reply_to, msg)
      converted_input = convert_input(msg)
      speak "#{from} says #{converted_input}" if (converted_input != "")
  end
  
  def botmsg(bot, target, msg)
      converted_input = convert_input(msg)
      speak "I say #{converted_input}" if (converted_input != "")
  end

private
  
  def speak(text) 
    system "say \"#{text}\""
  end

  def convert_input(s) 
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
       gsub(/[^a-zA-ZåäöÅÄÖ ,.!?'#€%\/()\-_<>]/u,"")
  end
end
