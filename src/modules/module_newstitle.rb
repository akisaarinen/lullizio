require 'htmlentities'

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

  def botmsg(bot,target,msg) end

  private

  def parseNewsTitle(url)
    hosts = {
      [/.*iltalehti\.fi/, /.*/] => /(.*) \| Iltalehti\.fi$/,
      [/.*iltasanomat\.fi/, /.*/] => /(.*) -[ ]+Ilta-Sanomat$/,
      [/.*hs\.fi/, /artikkeli\/[0-9]+(\?)?/] => /(.*) - HS.fi/,
      [/.*mtv3\.fi/, /.*/] => /(.*) - MTV3.fi/
    }
    image_paths = [
      /.*\.jpg/,
      /.*\.jpeg/,
      /.*\.gif/,
      /.*\.png/
    ]

    coder = HTMLEntities.new

    hosts.each { |params, title_expr|
      host = params[0]
      path = params[1]
      if URI.parse(url).host =~ host && URI.parse(url).path =~ path
        image_paths.each { |image_path|
          return "" if URI.parse(url).path =~ image_path
        }
        reply = fetch_uri(url)
        return "HTML error ##{reply.code}, sry :(" if (reply.code != "200")
        return $1 if reply.body =~ /<title>(.*)<\/title>/ && coder.decode($1) =~ title_expr
        return "Unable to find title"
      end
    }
    ""

  end
end

