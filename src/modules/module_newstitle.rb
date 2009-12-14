Kernel.load("fetch_uri.rb")

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

class Bot
  def newstitle_privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http:\/\//
        news_title = parseNewsTitle(word)
        bot.privmsg(reply_to, news_title) if news_title != ""
      end
    }
  end
end

