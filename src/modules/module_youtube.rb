require 'uri'
require 'net/http'

Kernel.load('fetch_uri.rb')

class Module_Youtube
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /youtube.com\/watch?/
        youtube_title = parseYoutube(word)
        bot.send_privmsg(reply_to, youtube_title)
      end
    }
  end

  private

  def parseYoutube(url)
    if URI.parse(url).host =~ /.*youtube\.com/
      video = URI.parse(url).query.match(/v=([^ &]*)/)[0][2,15]
      api = "http://gdata.youtube.com/feeds/api/videos/" + video
      print api + "\n"

      reply = fetch_uri(api)
      return "" if (reply.code != "200") 
      
      title = "?"
      rating = "?"
      views = "?"

      title = $1 if reply.body =~ /.*<title type='text'>(.*)<\/title>.*/
      rating = $1 if reply.body =~ /.*<gd:rating average='([0-9.]*)'.*/
      ratingcount = $1 if reply.body =~ /.*numRaters='([0-9]*)'.*/
      views = $1 if reply.body =~ /.*<yt:statistics favoriteCount='[0-9]*' viewCount='([0-9]*)'\/>.*/
      average = ((rating.to_f * 100).round).to_f / 100

      "#{title} (rating: #{average} (#{ratingcount}), views: #{views})"
    else
      ""
    end
  end
end

