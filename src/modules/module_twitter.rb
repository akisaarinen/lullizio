# -*- encoding : utf-8 -*-
require 'htmlentities'
require 'json'
require 'twitter'

Kernel.load("fetch_uri.rb")

class Module_Twitter
  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http[s]?:\/\/(.*\.|)twitter.com\/(.*)\/status(|es)\/([0-9]+)/
        reply = Twitter.status($4)
        user = reply['user']['screen_name']
        full = reply['user']['name']
        text = reply['text']
        reply_str = "@#{user} (#{full}): #{text}"
        bot.send_privmsg(reply_to, reply_str)
      end
    }
  end

  def botmsg(bot,target,msg) end
end

