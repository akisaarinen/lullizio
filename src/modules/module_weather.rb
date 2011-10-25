require 'uri'
require 'net/http'
require 'nokogiri'

Kernel.load('fetch_uri.rb')

class Module_Weather
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)

    msg.split(" ").each { |word|
      if word =~ /^s[\344][\344]$|^sää$/
        bot.send_privmsg(reply_to, find_weather())
      end
    }
  end
  def botmsg(bot,target,msg) end

  private

  def find_weather
    uri = "http://m.foreca.fi/index.php?l=100660158"
    reply = fetch_uri(uri)
    return "" if (reply.code != "200")

    doc = Nokogiri::HTML(reply.body)

    trs = doc.css("#cc tr")

    datetd = trs[0].css("th").first.content
    timetd = trs[2].css("td")[0].content
    degreetd = trs[2].css("td")[1].css("span").first.content
    infotd = trs[3].css("td").first

    date = ""
    if datetd =~ /Current conditions ([\d]+)\/([\d+]+)/
      date = "#{$1}.#{$2}. "
    end

    feels_like = ""
    if infotd.content =~ /.*(Feels Like: [^ \t]+).*/
       feels_like = ", #{$1}"
    end
    at = infotd.css("a").first.content
    return "#{date}kello #{timetd}: #{degreetd} C#{feels_like} (#{at})"
  end
end

