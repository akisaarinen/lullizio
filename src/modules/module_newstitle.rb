Kernel.load("fetch_uri.rb")

class Module_Newstitle
  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http:\/\//
        news_title = parseNewsTitle(word)
        bot.send_privmsg(reply_to, news_title) if news_title != ""
      end
    }
  end

  private

  def parseNewsTitle(url)
    hosts = {
      /.*iltalehti\.fi/ => /(.*) \| Iltalehti\.fi$/,
      /.*iltasanomat\.fi/ => /(.*) - Ilta-Sanomat$/
    }

    hosts.each { |host, title_expr|
      if URI.parse(url).host =~ host
        reply = fetch_uri(url)
        return "HTML error ##{reply.code}, sry :(" if (reply.code != "200") 
        return $1 if reply.body =~ /<title>(.*)<\/title>/ && $1 =~ title_expr
      end
    }
    ""
  end
end

