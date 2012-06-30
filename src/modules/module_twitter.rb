require 'htmlentities'
require 'json'

Kernel.load("fetch_uri.rb")

class Module_Twitter
  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http[s]?:\/\/(.*\.|)twitter.com\/(.*)\/status(|es)\/([0-9]+)/
        reply = requestStatus($4)
        user = reply['user']['screen_name']
        full = reply['user']['name']
        text = reply['text']
        reply_str = "@#{user} (#{full}): #{text}"
        bot.send_privmsg(reply_to, reply_str)
      end
    }
  end

  def botmsg(bot,target,msg) end

  private

  def requestStatus(id) 
    uri = "http://api.twitter.com/1/statuses/show/#{id}.json"
    reply = fetch_uri(uri)
    JSON.parse(reply.body)
  end
end

