# -*- encoding : utf-8 -*-
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
    uri = "http://m.foreca.fi/index.php?l=100658225"
    reply = fetch_uri(uri)
    return "" if (reply.code != "200")

    doc = Nokogiri::HTML(reply.body)
    trs = doc.css("#cc tr")

    day, month = /([\d]+)\/([\d]+)/.match(trs.first.css("th").first.content)[1,2]
    time = trs[2].css("td")[0].content
    real_temp = trs[2].css("td span").first.content
    feels_like = /Feels Like: ([^ \t]+)/.match(trs[3].css("td").first.content)[1]
    location = trs[3].css("td a").first.content
    return "#{real_temp} C, feels like #{feels_like} C, #{day}.#{month}. #{time} @#{location}"
  end
end

