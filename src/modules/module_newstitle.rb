# -*- encoding : utf-8 -*-
require 'htmlentities'

Kernel.load("fetch_uri.rb")

class Module_Newstitle
  TITLE_REGEXS = {
      [/.*iltalehti\.fi/, /.*/] => /(.*) \| Iltalehti\.fi$/,
      [/.*iltasanomat\.fi/, /.*/] => /(.*) -[ ]+Ilta-Sanomat$/,
      [/.*hs\.fi/, /artikkeli\/[0-9]+(\?)?/] => /(.*) - HS\.fi/,
      [/.*mtv3\.fi/, /.*/] => /(.*) - MTV3.fi/,
      [/.*talouselama\.fi/, /uutiset\/.*/] => /(.*) -[\W]+Talouselämä/,
      [/.*kauppalehti\.fi/, /i\/.*\/uuti(nen|set).jsp?.*/] => /(.*) \| Kauppalehti.fi/,
      [/.*yle\.fi/, /.*\.html/] => /(.*) \| yle\.fi/
    }
  IGNORED_IMAGE_PATHS = [
    /.*\.jpg/,
    /.*\.jpeg/,
    /.*\.gif/,
    /.*\.png/
  ]

  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http:\/\//
        fetch_newstitles(word).each do |title|
          bot.send_privmsg(reply_to, title)
        end
      end
    }
  end

  def botmsg(bot,target,msg) end

  private

  def fetch_newstitles(url)
    return [] if is_ignored_image_path(url)

    coder = HTMLEntities.new
    TITLE_REGEXS.map { |(host, path), title_expr|
      if URI.parse(url).host =~ host && URI.parse(url).path =~ path
        begin
          reply = fetch_uri(url)
          if reply.code != "200"
            "HTML error ##{reply.code}, sry :("
          elsif reply.body =~ /<title>(.*)<\/title>/m && coder.decode($1) =~ title_expr
            $1.strip
          else
            "Unable to find title"
          end
        rescue => e
          "Error #{e.message}"
        end
      end
    }.select {|title| title != nil }
  end

  def is_ignored_image_path(url)
    IGNORED_IMAGE_PATHS.map { |image_path|
      (URI.parse(url).path =~ image_path) != nil
    }.include?(true)
  end
end

